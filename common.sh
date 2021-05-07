#!/bin/bash

source config

function info() {
	message=$1

	echo ${message} >> /dev/tty
}

function log() {
	printf '%s\n' "$@"
}

# This works with ops manager
function get_automation() {
	result=$(curl -s --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
		--header "Accept: application/json" \
		--header "Content-Type: application/json" \
		--request GET "${URL}/groups/${PROJECTID}/automationConfig");

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

# Atlas functions
function create_cluster() {
	config=$(cat <<-EOF
	 {
         "name": "${CLUSTERNAME}",
         "numShards": 1,
         "providerSettings": {
           "providerName": "GCP",
           "instanceSizeName": "${CLUSTERSIZE}",
           "regionName": "EUROPE_WEST_2"
         },
         "clusterType" : "REPLICASET",
         "backupEnabled": ${BACKUPENABLED},
         "providerBackupEnabled" : true
	 }		
	EOF
	)
	info "${config}"

	result=$(curl -s --user "${PUBLICKEYPROJ}:${PRIVATEKEYPROJ}" --digest \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--request POST "${URL}/groups/${PROJECTID}/clusters" \
		--data ''"${config}"'')

#	rm temp.json
	info "${result}"
}

function delete_cluster() {
	result=$(curl -s --user "${PUBLICKEYPROJ}:${PRIVATEKEYPROJ}" --digest \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--request DELETE "${URL}/groups/${PROJECTID}/clusters/${CLUSTERNAME}")

#	rm temp.json
	info "${result}"
}

#function create_user() {
#	payload=$(cat -EOF<<
#	{
#         "username": "jane.doe@mongodb.com",
#         "emailAddress": "jane.doe@mongodb.com",
#         "firstName": "Jane",
#         "lastName": "Doe",
#         "password": "M0ng0D8!:)",
#         "roles": [{
#           "groupId": "533daa30879bb2da07807696",
#           "roleName": "GROUP_USER_ADMIN"
#         },{
#           "orgId" : "55555bbe3bd5253aea2d9b16",
#           "roleName" : "ORG_MEMBER"
#         }]
#       }
#   EOF)
#	echo ${payload} > temp.json
#
#	result=$(curl -s --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
#		--header 'Accept: application/json' \
#		--header 'Content-Type: application/json' \
#		--request PUT "${URL}/api/public/v1.0/groups/${PROJECTID}/automationConfig" \
#		--data @temp.json)
#
#	rm temp.json
#	echo ${result};
#}
#
