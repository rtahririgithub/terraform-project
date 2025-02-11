#!/bin/bash

HOST_PROJECT="cio-stackdriver-np-c4636c"
OUTPUT=notificationchannels.json

curl --location --request GET "https://monitoring.googleapis.com/v3/projects/$HOST_PROJECT/notificationChannels?pageSize=1000" \
    -H "$(../oauth2l header --json ../sa.json cloud-platform userinfo.email)" \
    --header 'Content-Type: application/json' \
    > $OUTPUT
