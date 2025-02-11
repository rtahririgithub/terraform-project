#!/bin/bash

shopt -s extglob

terraform="terraform"

FILES=$(find . -name *.json)
ROLES="owners managers members"
BRANCH_NAME=$1


#Global scoped config for ease of manipulation
groupConfiguration=""

#Get All the sevice accounts
gcloud asset search-all-resources   \
    --scope='organizations/637987714668'    \
    --asset-types='iam.googleapis.com/ServiceAccount'   \
    --format=json | jq -r '.[].additionalAttributes.email' > sa.txt

#Get all the project numbers
FOLDERS=( 
    1005536627874 #CTO	
    1061297587408 #Shared Infrastructure	
    191872932537 #Assured Workload	
    223148886473 #CPO	
    261918639929 #CDO	
    31016996448 #Agriculture	
    341784513093 #Digital Products	
    524359446456 #Belgaroth	
    525612506323 #HSCE	
    536710404454 #TSBT	
    561041907986 #CTE	
    694170895437 #CDE	
    808431163417 #NETOPS	
    927409160502 #CSO	
    954186428011 #Digital	
    960225691252 #GIDC	
    )

for folder in "${FOLDERS[@]}" 
do
    echo $folder
    gcloud asset search-all-resources   --scope="folders/$folder"  \
        --asset-types='cloudresourcemanager.googleapis.com/Project' \
        --format="value(project)" \
        --query="state:ACTIVE" |  cut -d'/' -f2 >> project.txt
done

cat project.txt

AUTH_CODE=$(curl --request POST \
  'https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/gcp-group-management%40gcp-groups-pr-c6c009.iam.gserviceaccount.com:generateAccessToken' \
  --header "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{"lifetime":"3600s","scope":["https://www.googleapis.com/auth/admin.directory.user","https://www.googleapis.com/auth/admin.directory.domain.readonly"]}' \
  --compressed | jq -r .accessToken )

AUTH_HEADER="Authorization: Bearer $AUTH_CODE"

validateServiceAccount() {
    sa=$1
    grep $sa sa.txt  > /dev/null
    result=$? 
    if [[ "$result" = "0" ]]
    then
        echo "validServiceAccount"
    else
       echo "invalidServiceAccount"
    fi
}


validateProjectNumber() {
    projectNumber=$1
    grep "$projectNumber" project.txt  > /dev/null
    result=$? 
    if [[ "$result" = "0" ]]
    then
        echo "validProjectNumber"
    else
       echo "invalidProjectNumber"
    fi
}

echo $AUTH_HEADER

#Sort the file using JQ
jqSort() {
    unsortedFile=$1
    echo "Sorting $unsortedFile"
    groupConfiguration=$( jq '{id: .id, displayName:.displayName, owners:.owners|sort, managers:.managers|sort, members:.members|sort}' $unsortedFile )
    echo "Sorted"
}


validateUser()
{
    user=$1
    role=$2
    file=$3
    case $user in 
        *iam.gserviceaccount.com )
            let validServiceAgent=false
            let validServiceAccount=false 
            if ( [[ "$user" == *storage-transfer-service.iam.gserviceaccount.com ]] || [[ "$user" == *gcp-sa-aiplatform-cc.iam.gserviceaccount.com ]] || [[ "$user" == *gcp-sa-aiplatform.iam.gserviceaccount.com ]] || [[ "$user" ==  *serverless-robot-prod.iam.gserviceaccount.com ]] )
            then
                echo "Looking for service agent $user"
                number=$(echo $user | cut -d'@' -f1 | cut -d'-' -f2)
                echo "Project Number: $number"
                result=$(validateProjectNumber $number)
                echo "Result: $result"
                if [ "$result" = "validProjectNumber" ] 
                then 
                    echo "Valid service agent: $user"
                    validServiceAgent=true 
                else
                    echo "Invalid service agent: $user"
                    validServiceAgent=false
                fi
            else
                echo "Looking for service account $user"
                result=$(validateServiceAccount $user)
                if [ "$result" = "validServiceAccount" ]
                then 
                    echo "Valid service account: $user"
                    validServiceAccount=true
                else
                    echo "Invalid service account: $user"
                    validServiceAccount=false
                fi
            fi 
            if ( [ "$validServiceAccount" = "true" ] || [ "$validServiceAgent" = "true" ] )
            then
                echo "Valid Service Account / Service Agent"
            else
                echo "Invalid Service Account / Service Agent"
                deleteUserFromState $user $role $file
                deleteUserFromConfig $user $role
            fi
            ;;
        *@cloudbuild.gserviceaccount.com* )
            echo "Looking for cbsa $user"
            number=$(echo $user | cut -d'@' -f1)
            echo "Project Number: $number"
            result=$(validateProjectNumber $number)
            echo "Result:$result"
            if [ "$result" = "validProjectNumber" ]
            then
                echo "Valid cloud build service account: $user"
            else
                echo "Invalid cloud build service account: $user"
                deleteUserFromState $user $role $file
                deleteUserFromConfig $user $role
            fi
            ;;
        * )
            echo "Default lookup: $user"
            responseCode=$(
                curl -s -o /dev/null -w "%{http_code}" \
                --header "$AUTH_HEADER" \
                --header 'Accept: application/json' \
                --compressed \
                "https://admin.googleapis.com/admin/directory/v1/users/$user")
            if ( [ "$responseCode" = "403" ] || [ "$responseCode" = "404" ] )
            then
                echo "$responseCode : Invalid user: $user"    
                deleteUserFromState $user $role $file
                deleteUserFromConfig $user $role
            elif [ "$responseCode" = "200" ]
            then
                echo "$responseCode : Valid user: $user"
            else
                echo "$responseCode: Unknown response code: $user"
            fi
    esac
}

#Remove the user from terraform state
deleteUserFromState()
{
    user=$1
    role=$2
    
    #Remove leading ./ from file
    file=$( echo $3 | sed 's/^\.\///' )
    stateAddress="google_cloud_identity_group_membership.$role[\"$file|$user\"]"
    echo "Removing stateAddress: $stateAddress"
    $terraform state rm "$stateAddress"
}

#Remove the user from configuration
deleteUserFromConfig()
{
    user=$1
    role=$2
    echo delete $user $role
    groupConfiguration=$( echo $groupConfiguration | jq "del(.$role[] | select(. == \"$user\") ) " )
}

#Primary Loop
for file in $FILES; do
    echo $file
    jqSort $file
    echo $groupConfiguration
    for role in $ROLES; do
        echo $role
        USERS=$( echo $groupConfiguration | jq -r ".$role[]")
        for user in $USERS; do
            echo "---------------"
            validateUser $user $role $file
        done
    done
    #Output the final file
    echo $groupConfiguration > ugly_print.json
    jq . ugly_print.json > $file
    rm -f ugly_print.json
done



