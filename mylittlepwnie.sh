#!/bin/bash
#
# This little licorn just check for verb-tempering on a specific endpoint
#
# Owner : Baxytra

set -euo pipefail

# Script vars
url="${1}"

usage() {
	# Present the script usage
	
	echo 'This little licorn just check for verb-tempering on a specific endpoint'
	echo "Usage :  $(basename "${0}") <URL>"
}

currentPageStatus() {
	# Return current response when unauthorized
	
	unauthorized=$(curl -i -s "$1")
}

checkVerbTempering() {
	# Test for verbtempering on specified endpoint
	# Try verb-tempering with POST, PUT, DELETE, TRACE, CONNECT, OPTIONS

	declare -a methods=("POST PUT DELETE TRACE CONNECT OPTIONS")
	for method in $methods; do
		echo "[*] Tested : ${method}"
		verbTempered=$(curl -i -s -X "${method}" "$1")
		if [ "${unauthorized}" != "${verbTempered}" ]; then
			httpCode=$(echo "${verbTempered}"| grep -E 'HTTP/1.1 [0-9]{3}' | awk '{ print $2 }')
			if ! echo "${httpCode}" | grep -qE "40[0-9]"; then
				echo "[+] Found : method ${method} return code ${httpCode}"
			fi
		fi
	done
}

currentPageStatus "${url}"
checkVerbTempering "${url}"
