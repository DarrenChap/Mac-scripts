#!/bin/bash
# This script is provided AS IS without warranty of any kind.
# https://github.com/Mac-Nerd/Mac-scripts
# -----------------------------------------------------------

# Check your privilege
if [ $(whoami) != "root" ]; then
    echo "This script must be run with root/sudo privileges."
    exit 1002
fi

convertAccount="$1"

if ! id "$convertAccount" 2> /dev/null || [ -z "$1" ]
then
	echo "[ERROR] No such user: $convertAccount"
	exit 1001
fi

if /usr/bin/dscl . -read "/groups/admin" GroupMembership | /usr/bin/grep -q "$convertAccount"
then
	echo "$convertAccount is already an administrator."
else
	if /usr/bin/dscl . -append "/groups/admin" GroupMembership "$convertAccount"
	then
		echo "$convertAccount now has administrator privileges."
	else
		echo "[ERROR] Could not grant user $convertAccount administrator privileges."
		exit 1003	
	fi
fi
