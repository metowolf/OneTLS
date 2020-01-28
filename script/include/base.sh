#!/bin/bash

. ${onetls_dir}/script/include/colors.sh
. ${onetls_dir}/script/include/copyright.sh

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

warning() {
	echo -e "${YELLOW}WARN${RESET}:\t$@" >&2
}

error() {
	echo -e "${RED}ERROR${RESET}:\t$@" >&2
}