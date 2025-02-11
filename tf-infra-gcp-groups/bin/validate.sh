FILES=$1
ROLES="owners managers members"

#Global scoped config for ease of manipulation
groupConfiguration=""
error=0
emailRegex="^(([-a-z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))\.)*([-a-z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,4}$"
validateUser()
{
    user=$1
    role=$2
    file=$3

    #Cannot validate service accounts with this service account
    # echo $user
    if [[ $user =~ (telus.com)|(gserviceaccount.com) ]];
    then
        b=1
    else 
        echo "$user is not in a valid domain. Please review README.md"
        error=1
    fi

    if [[ $user =~ $emailRegex ]];
    then
        b=1
    else 
        echo "$user is not in a valid email address. Please review README.md"
        error=1
    fi

}


#Primary Loop
for file in $FILES; do
    
    jq empty $file
    if [[ $? != "0" ]]
    then
        echo "$file is not valid JSON"
        error=1
    fi

    echo $file
    echo $groupConfiguration
    for role in $ROLES; do
        echo $role
        groupConfiguration=$( jq '{id: .id, displayName:.displayName, owners:.owners|sort, managers:.managers|sort, members:.members|sort}' $file ) 
        USERS=$( echo $groupConfiguration | jq -r ".$role[]")
        for user in $USERS; do
            validateUser $user $role $file
        done
    done
done

exit $error