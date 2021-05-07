#!/bin/bash

. config
. common.sh

result="$(get_automation)"

echo ${result}|jq
