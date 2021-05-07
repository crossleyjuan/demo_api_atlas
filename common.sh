#!/bin/bash

source config

function info() {
	message=$1

	echo ${message} >> /dev/tty
}

function log() {
	printf '%s\n' "$@"
}

function get_automation() {
	result=$(curl -s --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
		--header "Accept: application/json" \
		--header "Content-Type: application/json" \
		--request GET "${URL}/api/public/v1.0/groups/${PROJECTID}/automationConfig");

	echo ${result};
}

function update_automation() {
	config=$1
	echo ${config} > temp.json

	result=$(curl -s --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--request PUT "${URL}/api/public/v1.0/groups/${PROJECTID}/automationConfig" \
		--data @temp.json)

	rm temp.json
	echo ${result};
}

function create_user() {
	payload=$(cat -EOF<<
	{
         "username": "jane.doe@mongodb.com",
         "emailAddress": "jane.doe@mongodb.com",
         "firstName": "Jane",
         "lastName": "Doe",
         "password": "M0ng0D8!:)",
         "roles": [{
           "groupId": "533daa30879bb2da07807696",
           "roleName": "GROUP_USER_ADMIN"
         },{
           "orgId" : "55555bbe3bd5253aea2d9b16",
           "roleName" : "ORG_MEMBER"
         }]
       }
   EOF)
	echo ${payload} > temp.json

	result=$(curl -s --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--request PUT "${URL}/api/public/v1.0/groups/${PROJECTID}/automationConfig" \
		--data @temp.json)

	rm temp.json
	echo ${result};
}

