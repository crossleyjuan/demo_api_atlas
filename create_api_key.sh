#!/bin/bash

. config

function createapikey() {
	result=$(curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
		--header "Accept: application/json" \
		--header "Content-Type: application/json" \
		--request POST "${URL}/api/public/v1.0/orgs/${ORGID}/apiKeys?pretty=true" \
		--data '{
			"desc" : "New API key for testproject purposes",
			"roles": ["ORG_OWNER"]
		}')

	#result=$(cat testapi.txt)
	gen_publicKey=$(echo $result | jq .publicKey | sed -e "s/\"//g" )
	gen_privateKey=$(echo $result | jq .privateKey | sed -e "s/\"//g" )
	apikeyid=$(echo $result | jq .id | sed -e "s/\"//g" )

	cat <<EOF > secret_rs.yaml
apiVersion: v1
kind: Secret
metadata:
  name: rs-credentials # Name of the 'Secret'
data:
  user: $(echo -n ${gen_publicKey} | base64)  # ${gen_publicKey}
  publicApiKey: $(echo -n ${gen_privateKey} | base64)  #  ${gen_privateKey}
EOF

	echo ${apikeyid}
	return 0
}

function whitelist() {
	APIKEYID=$1

	result=$(curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--include \
--request POST "${URL}/api/public/v1.0/orgs/${ORGID}/apiKeys/${APIKEYID}/whitelist?pretty=true" \
--data '
  [{

    "ipAddress" : "'${IPWHITELIST}'"
}]')
}


apikey=$(createapikey)
whitelist ${apikey}

echo "Created the API Key ${apikey} in secret_rs.yaml"
