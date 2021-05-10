#!/bin/bash

. config
. common.sh

function usage() {
	echo "create-cluster.sh -n <name> [-r name] [-s size] [-b] [-v version]"
	echo ""
	echo "-n <name>       Cluster Name"
	echo "-r <name>       Region Name (Default EUROPE_WEST_2)"
	echo "-s <size name>  Size name for example M10"
	echo "-b              If specified then the backup will be enabled."
	echo "-v <version>    Specifies the mongodb version: 4.0, 4.2 or 4.4 (default)"
	echo ""
	echo "Example:"
	echo "./create-cluster -n Cluster1 -s M10"
}

BACKUPENABLED=false
MONGODBVERSION=
REGIONNAME=EUROPE_WEST_2
while getopts ":n:s:r:v:b" o; do
    case "${o}" in
        n)
            CLUSTERNAME=${OPTARG}
            ;;
        s)
            CLUSTERSIZE=${OPTARG}
            ;;
        r)
            REGIONNAME=${OPTARG}
            ;;
        b)
            BACKUPENABLED=true
            ;;
        v)
            MONGODBVERSION=${OPTARG}
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

function create_cluster() {
	config=$(cat <<-EOF
	 {
         "name": "${CLUSTERNAME}",
         "numShards": 1,
         "providerSettings": {
           "providerName": "GCP",
           "instanceSizeName": "${CLUSTERSIZE}",
           "regionName": "${REGIONNAME}"
         },
         "clusterType" : "REPLICASET",
         "providerBackupEnabled": ${BACKUPENABLED}
	 }		
	EOF
	)
	if [ ! -z "${MONGODBVERSION}" ];
	then
		config=$(echo "${config}" | jq '.mongoDBMajorVersion = "'${MONGODBVERSION}'"')
	fi
	info "${config}"

	result=$(curl -s --user "${PUBLICKEYPROJ}:${PRIVATEKEYPROJ}" --digest \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--request POST "${URL}/groups/${PROJECTID}/clusters" \
		--data ''"${config}"'')

	echo "${result}"
}

result=$(create_cluster)

echo ${result}|jq .


