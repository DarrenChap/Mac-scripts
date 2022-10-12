#!/bin/bash

# This script will alert when the Integrated Bitdefender Antivirus is not running. It will
# try to determine why, based on the RMM agent logs and configuration, and return the
# appropriate message in the script check's output.


# This script is provided AS IS without warranty of any kind.
# https://github.com/Mac-Nerd/Mac-scripts
# -----------------------------------------------------------

if ! pgrep -qf ManagedAntivirus # installed and activated, but is it running?
	then
	echo "[ERROR] Managed AV is not running."

	# Not running. Is MAV enabled?
	if ! grep -i "feature.ManagedAvBreckenridge.enabled=true" "/usr/local/rmmagent/.agentcontext.cfg"
	then
		echo "[ERROR] Managed AV not enabled."
		# there's the problem.
		exit 1005

	# enabled, not running. is it installed?
	elif ! grep -E "\"install.*ManagedAvBreckenridge.*succeeded" "/Library/Logs/RMM\ Advanced\ Monitoring\ Agent/rmmagentd.log" 
	then
		echo "[ERROR] Managed AV is not installed."
		exit 1004
		
	# enabled, installed, is it activated?
	elif ! grep -E "MavBreckFeature.*substatus.*None.*installed" "/Library/Logs/RMM\ Advanced\ Monitoring\ Agent/rmmagentd.log"
	then
		echo "[ERROR] Managed AV is installed and activated, but not running."
		exit 1003

	# enabled, installed, but not running. is it pending activation?
	elif grep -E "MavBreckFeature.*Pending" "/Library/Logs/RMM\ Advanced\ Monitoring\ Agent/rmmagentd.log"
	then
		echo "[NOTICE] Managed AV installed, but pending activation."
		exit 1002
		
	else 
		echo "Unknown error."
		exit 1001
	fi

else 
	echo "[SUCCESS] Managed AV is running."
	exit 0
	
fi
	
