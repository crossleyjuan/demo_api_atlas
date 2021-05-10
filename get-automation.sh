#!/bin/bash

. common.sh

function get_automation() {
	result=$(curl -s --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
		--header "Accept: application/json" \
		--header "Content-Type: application/json" \
		--request GET "${URL}/groups/${PROJECTID}/automationConfig");

	echo ${result};
}

result="$(get_automation)"

echo ${result}|jq
