#!/bin/bash

#Read from the supplied map
eval "$(jq -r '@sh "PROJECT=\(.project_id) ENV=\(.env) STATE=\(.state)"')"

#Get the state file
gsutil cp gs://tf-state-$PROJECT/terraform/$ENV/$STATE/default.tfstate $STATE.tfstate >> /dev/null 2>&1

#Parse the state file
STEP1=`jq '.resources[] | select (.type=="google_monitoring_alert_policy") | {(.instances[0].attributes.display_name): .instances[0].attributes.id} ' ./$STATE.tfstate  `
STEP2=`echo $STEP1 | jq -s '. |add' `

#Send the response to STDOUT
echo $STEP2


