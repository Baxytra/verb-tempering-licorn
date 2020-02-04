#!/bin/bash
#
# This little unicorn just check for verb-tempering on a specific endpoint
#
# Owner : Baxytra

usage() {
	# Present the script usage
	
	echo 'This little unicorn just check for verb-tempering on a specific endpoint'
	echo "Usage :  $(basename "${0}") <URL>"
}

callUnicorn() {
	# Hey ! Unicorn !
	b64Unicorn="ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLwogICAgICAgICAgICAgICAgICAgX18gICAgICAgLy8KICAgICAgICAgICAgICAgICAgIC1cPSBcPVwgLy8KICAgICAgICAgICAgICAgICAtLT1fXD0tLS0vLz0tLQogICAgICAgICAgICAgICAtXz09LyAgXC8gLy9cLy0tCiAgICAgICAgICAgICAgICA9PS8gICAvTyAgIE9cPT0tLQogICBfIF8gXyBfICAgICAvXy8gICAgXCAgXSAgLy0tCiAgL1wgKCAoLSBcICAgIC8gICAgICAgXSBdIF09PS0KIChcIF9cX1xfXC1cX18vICAgICBcICAoLF8sKS0tCihcXy8gICAgICAgICAgICAgICAgIFwgICAgIFwtClwvICAgICAgLyAgICAgICAoICAgKCBcICBdIC8pCi8gICAgICAoICAgICAgICAgXCAgIFxfIFwuLyApCiggICAgICAgXCAgICAgICAgIFwgICAgICApICBcCiggICAgICAgL1xfIF8gXyBfIC8tLS0vIC9cXyAgXAogXCAgICAgLyBcICAgICAvIF9fX18vIC8gICBcICBcCiAgKCAgIC8gICApICAgLyAvICAvX18gKSAgICggICkKICAoICApICAgLyBfXy8gJy0tLWAgICAgICAgLyAvCiAgXCAgLyAgIFwgXCAgICAgICAgICAgICBfLyAvCiAgXSBdICAgICApX1xfICAgICAgICAgL19fXC8KICAvX1wgICAgIF1fX19cCiAoX19fKQo=" 
	echo "${b64Unicorn}"| base64 -d
	echo -e "\n\n"
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

if [ -z $1 ]; then
	usage
	exit 0
fi

url="${1}"
callUnicorn
currentPageStatus "${url}"
checkVerbTempering "${url}"
