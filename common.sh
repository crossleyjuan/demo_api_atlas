#!/bin/bash


function info() {
	message=$1

	echo ${message} >> /dev/tty
}

function log() {
	printf '%s\n' "$@"
}

# This works with ops manager
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

