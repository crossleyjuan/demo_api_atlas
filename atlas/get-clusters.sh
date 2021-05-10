#!/bin/bash

source ../config
source ../common.sh

result=$(curl -s --user "${PUBLICKEYPROJ}:${PRIVATEKEYPROJ}" --digest \
	--header "Accept: application/json" \
	--header "Content-Type: application/json" \
	--request GET "${URL}/api/public/v1.0/groups/${PROJECTID}/clusters")

echo ${result}|jq .
