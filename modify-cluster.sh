#!/bin/bash

. config
. common.sh

function usage() {
	echo "modify-cluster.sh params"
	echo ""
	echo "-n <name>       Cluster Name"
	echo "-s <size name>  Size name for example M10"
	echo "-r <name>       Region Name (Default EUROPE_WEST_2)"
	echo "-b true|false   If specified then the backup will be enabled."
	echo "-v <version>    Specifies the mongodb version: 4.0, 4.2 or 4.4 (default)"
	echo ""
	echo "Example:"
	echo "./modify_cluster-cluster -n Cluster1 -s M10"
}

BACKUPENABLED=
REGIONNAME=EUROPE_WEST_2
MONGODBVERSION=
while getopts ":n:s:r:v:b:" o; do
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
            BACKUPENABLED=${OPTARG}
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

if [ -z "${CLUSTERNAME}" ]; then
    usage
	exit 1
fi

if [ -z "${BACKUPENABLED}" ] && [ -z "${CLUSTERSIZE}" ] && [ -z "${MONGODBVERSION}" ]; then
    usage
	exit 1
fi

function modify_cluster() {
	config=$(cat <<-EOF
	 {
	 }		
	EOF
	)

	if [ ! -z "${CLUSTERSIZE}" ];
	then
		settings=$(cat <<-EOF
         {
           "providerName": "GCP",
           "instanceSizeName": "${CLUSTERSIZE}",
           "regionName": "${REGIONNAME}"
         }
		EOF
		)
		config=$(echo "${config}" | jq '.providerSettings = '"${settings}"'')
	fi
	if [ ! -z "${BACKUPENABLED}" ];
	then
		config=$(echo "${config}" | jq '.providerBackupEnabled = '${BACKUPENABLED}'')
	fi
	if [ ! -z "${MONGODBVERSION}" ];
	then
		config=$(echo "${config}" | jq '.mongoDBMajorVersion = "'${MONGODBVERSION}'"')
	fi
	info "${config}"

	result=$(curl -s --user "${PUBLICKEYPROJ}:${PRIVATEKEYPROJ}" --digest \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--request PATCH "${URL}/groups/${PROJECTID}/clusters/${CLUSTERNAME}" \
		--data ''"${config}"'')

	echo "${result}"
}

result=$(modify_cluster)

echo ${result}|jq .


