#!/bin/bash

. config
. common.sh

function usage() {
	echo "create-db-user.sh <version>"
	echo ""
	echo "Example:"
	echo "./create-db-user "
}

version=$1
if [ "${version}" == "" ];
then
	echo "Error: Missing parameter version"
	usage
	exit 1
fi

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

	result=$(curl -s --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--request PUT "${URL}/api/public/v1.0/groups/${PROJECTID}/automationConfig" \
		--data ''"${payload}"'')

	echo "${result}"
}


result="$(create_user)"
echo "${result}"|jq .


