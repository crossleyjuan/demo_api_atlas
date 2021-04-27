#!/bin/bash

source config

function info() {
	message=$1

	echo ${message} >> /dev/tty
}
