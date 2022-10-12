#!/bin/bash

# This script is provided AS IS without warranty of any kind.
# https://github.com/Mac-Nerd/Mac-scripts
# -----------------------------------------------------------

# This script will attempt to gracefully quit a running app. If unsuccessful after a 
# set timeout (default 60 seconds) the application will be more forcefully quit.
# 
# Note: If the user has unsaved changes or open documents in the prohibited app, this will
# cause them to potentially be corrupted or lost. Use with caution.


AppToKill=$1
KillTimeout=$2

if [ -n "$AppToKill" ]
then
	echo "[ERROR] This script requires the name of an app or process to quit."
	exit 1002
fi

if [ -n "$KillTimeout" ]
then
	KillTimeout=60	# default 60s timeout
fi

currentUser=$(stat -f "%S"u /dev/console)
currentUID=$(/usr/bin/id -u "$currentUser")

if [ "$currentUser" == "LoginWindow" ]
then
	echo "No logged in user."
	exit 1001
else
	# is the application or process running?
	if [ $(pgrep -ilf "$AppToKill") ] || [ $(pgrep -ilf "$AppToKill".app) ]
	then
		echo "Found $AppToKill. Quitting it."
		/bin/launchctl asuser "$currentUID" /usr/bin/osascript -e "tell application \"${AppToKill}\" to quit"
	fi	
	
	sleep "$KillTimeout"
	
	# is the application or process *still* running?
	if [ $(pgrep -ilf "$AppToKill") ] || [ $(pgrep -ilf "$AppToKill".app) ]
	then
		echo "$AppToKill still running. Force quitting it."
		/usr/bin/pkill -9 -ilf "$AppToKill"
	fi	
	
fi



