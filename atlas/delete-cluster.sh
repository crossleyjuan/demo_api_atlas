#!/bin/bash

source ../config
source ../common.sh

function usage() {
	echo "delete-cluster.sh params"
	echo ""
	echo "-n <name>       Cluster Name"
	echo ""
	echo "Example:"
	echo "./delete-cluster -n Cluster1"
}

BACKUPENABLED=false
while getopts ":n:s:" o; do
    case "${o}" in
        n)
            CLUSTERNAME=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${CLUSTERNAME}" ]; then
    usage
	exit 1
fi

function delete_cluster() {
	result=$(curl -s --user "${PUBLICKEYPROJ}:${PRIVATEKEYPROJ}" --digest \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--request DELETE "${URL}/groups/${PROJECTID}/clusters/${CLUSTERNAME}")

	echo "${result}"
}

result=$(delete_cluster)

echo ${result}|jq



