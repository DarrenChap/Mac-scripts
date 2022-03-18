#!/bin/sh
# ----- Legal: ----
# Sample scripts are not supported under any N-able support program or service.
# The sample scripts are provided AS IS without warranty of any kind.
# N-able expressly disclaims all implied warranties including, warranties
# of merchantability or of fitness for a particular purpose.
# In no event shall N-able or any other party be liable for damages arising
# out of the use of or inability to use the sample scripts.
# ----- /Legal ----

# Set the hostname/ComputerName based on model ID and serial number instead of "username's MacBook":

# get the model ID without commas (eg, 'MacBookPro161')
ModelID=$(system_profiler SPHardwareDataType | awk '/Identifier/ {print $3}' | sed 's/,//g')

# get last 4 digits of the serial number
SerialNumber=$(system_profiler SPHardwareDataType | awk '/Serial/ {print substr($4,length($4)-3,4)}')

scutil --set HostName $ModelID-$SerialNumber.local
scutil --set LocalHostName $ModelID-$SerialNumber.local
scutil --set ComputerName "$ModelID $SerialNumber"
/usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName $ModelID-$SerialNumber
dscacheutil -flushcache
