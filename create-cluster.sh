#!/bin/bash

. config
. common.sh

function usage() {
	echo "create-cluster.sh params"
	echo ""
	echo "-n <name>       Cluster Name"
	echo "-s <size name>  Size name for example M10"
	echo "-b              If specified then the backup will be enabled."
	echo ""
	echo "Example:"
	echo "./create-cluster -n Cluster1 -s M10"
}

BACKUPENABLED=false
while getopts ":n:s:" o; do
    case "${o}" in
        n)
            CLUSTERNAME=${OPTARG}
            ;;
        s)
            CLUSTERSIZE=${OPTARG}
            ;;
        b)
            BACKUPENABLED=true
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${CLUSTERNAME}" ] || [ -z "${CLUSTERSIZE}" ]; then
    usage
	exit 1
fi
result=$(create_cluster)



