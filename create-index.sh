#!/bin/bash

. config
. common.sh

function usage() {
	echo "create-index.sh <version>"
	echo ""
	echo "Example:"
	echo "./create-index.sh 4.4.2"
}

create_index
