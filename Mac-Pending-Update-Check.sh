#!/bin/bash

# This script is provided AS IS without warranty of any kind.
# https://github.com/Mac-Nerd/Mac-scripts
# -----------------------------------------------------------

# Script check to alert on Apple updates marked "pending".

OSVERSION=$(defaults read /System/Library/CoreServices/SystemVersion ProductVersion | awk '{print $1}')

OSMAJOR=$(echo "${OSVERSION}" | cut -d . -f1)
#OSMINOR=$(echo "${OSVERSION}" | cut -d . -f2)

# check pending updates
if [[ $OSMAJOR -lt 11 ]]
then
	# 10x
	pendingUpdates=$(defaults read /Library/Updates/index.plist InstallAtLogout | grep -c "[A-Za-z0-9]")
else 
	# >10 - number of assets downloaded
	pendingUpdates=$(find /System/Library/AssetsV2/com_apple_MobileAsset_MacSoftwareUpdate/ -type d -d 1 | grep -c -i "asset")
fi

if [[ $pendingUpdates -gt 0 ]]
then
	echo "There are $pendingUpdates updates pending."
	exit 1001
else
	echo "No updates pending."
	exit 0
fi
	
