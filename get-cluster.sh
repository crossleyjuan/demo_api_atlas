#!/bin/bash

. config

export CLUSTERID=$1

if [ "${CLUSTERID}" == "" ];
then
	echo "missing parameter"
    exit 1
fi

echo ${CLUSTERID}

result=$(curl -s --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
	--header "Accept: application/json" \
	--header "Content-Type: application/json" \
	--request GET "${URL}/api/public/v1.0/groups/${PROJECTID}/automationConfig")

echo "${result}" | jq .
