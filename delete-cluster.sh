#!/bin/bash

. config
. common.sh

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
result=$(delete_cluster)



