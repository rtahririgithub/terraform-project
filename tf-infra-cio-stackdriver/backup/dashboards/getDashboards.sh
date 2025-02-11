#!/bin/bash

HOST_PROJECT="cio-stackdriver-np-c4636c"
OUTPUT=dashboards.json

curl --location --request GET "https://monitoring.googleapis.com/v1/projects/$HOST_PROJECT/dashboards" \
    -H "$(../oauth2l header --json ../sa.json cloud-platform userinfo.email)" \
    --header 'Content-Type: application/json' \
    > $OUTPUT
