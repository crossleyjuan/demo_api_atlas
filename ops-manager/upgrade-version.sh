#!/bin/bash

source ../config
source ../common.sh

function usage() {
	echo "update-version.sh <version>"
	echo ""
	echo "Example:"
	echo "./update-version.sh 4.4.2"
}

version=$1
if [ "${version}" == "" ];
then
	echo "Error: Missing parameter version"
	usage
	exit 1
fi

#version="4.4.2"
#version="4.2.11"

result="$(get_automation)"
#echo ${result} > automationConfig.json
#result="$(cat automationConfig.json)"

# Updates the version
automationConfig=$(echo ${result} |jq '.processes[].version = "'${version}'"')

result=$(update_automation "${automationConfig}")
echo "${result}"

