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

result="$(get_automation)"
#echo ${result} > automationConfig.json
#result="$(cat automationConfig.json)"

# Updates the version
automationConfig=$(echo ${result} |jq '.processes[].version = "'${version}'"')

result=$(update_automation "${automationConfig}")
echo "${result}"


