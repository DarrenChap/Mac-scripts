#!/bin/zsh

# ----- Legal: ----
# Sample scripts are not supported under any N-able support program or service.
# The sample scripts are provided AS IS without warranty of any kind.
# N-able expressly disclaims all implied warranties including, warranties
# of merchantability or of fitness for a particular purpose.
# In no event shall N-able or any other party be liable for damages arising
# out of the use of or inability to use the sample scripts.
# ----- /Legal ----

# !!! Terminal or process running this script will need Full Disk Access

# read the tcc.db and translate the following:
# service
# client
# auth_value
# auth_reason
# indirect_object_identifier
# last_modified

# source:
# https://www.rainforestqa.com/blog/macos-tcc-db-deep-dive

# TCC Translator arrays

# service
typeset -A ServiceArray
ServiceArray[kTCCServiceAddressBook]="Contacts"
ServiceArray[kTCCServiceAppleEvents]="Apple Events"
ServiceArray[kTCCServiceBluetoothAlways]="Bluetooth"
ServiceArray[kTCCServiceCalendar]="Calendar"
ServiceArray[kTCCServiceCamera]="Camera"
ServiceArray[kTCCServiceContactsFull]="Full contacts information"
ServiceArray[kTCCServiceContactsLimited]="Basic contacts information"
ServiceArray[kTCCServiceFileProviderDomain]="Files managed by Apple Events"
ServiceArray[kTCCServiceFileProviderPresence]="See when files managed by client are in use"
ServiceArray[kTCCServiceLocation]="Current location"
ServiceArray[kTCCServiceMediaLibrary]="Apple Music, music and video activity, and media library"
ServiceArray[kTCCServiceMicrophone]="Microphone"
ServiceArray[kTCCServiceMotion]="Motion & Fitness Activity"
ServiceArray[kTCCServicePhotos]="Read Photos"
ServiceArray[kTCCServicePhotosAdd]="Add to Photos"
ServiceArray[kTCCServicePrototype3Rights]="Authorization Test Service Proto3Right"
ServiceArray[kTCCServicePrototype4Rights]="Authorization Test Service Proto4Right"
ServiceArray[kTCCServiceReminders]="Reminders"
ServiceArray[kTCCServiceScreenCapture]="Capture screen contents"
ServiceArray[kTCCServiceSiri]="Use Siri"
ServiceArray[kTCCServiceSpeechRecognition]="Speech Recognition"
ServiceArray[kTCCServiceSystemPolicyDesktopFolder]="Desktop folder"
ServiceArray[kTCCServiceSystemPolicyDeveloperFiles]="Files in Software Development"
ServiceArray[kTCCServiceSystemPolicyDocumentsFolder]="Files in Documents folder"
ServiceArray[kTCCServiceSystemPolicyDownloadsFolder]="Files in Downloads folder"
ServiceArray[kTCCServiceSystemPolicyNetworkVolumes]="Files on a network volume"
ServiceArray[kTCCServiceSystemPolicyRemovableVolumes]="Files on a removable volume"
ServiceArray[kTCCServiceSystemPolicySysAdminFiles]="Administer the computer"
ServiceArray[kTCCServiceWillow]="Home data"
ServiceArray[kTCCServiceSystemPolicyAllFiles]="Full Disk Access"
ServiceArray[kTCCServiceAccessibility]="Control the computer"
ServiceArray[kTCCServicePostEvent]="Send keystrokes"
ServiceArray[kTCCServiceListenEvent]="Monitor input from the keyboard"
ServiceArray[kTCCServiceDeveloperTool]="Run insecure software locally"
ServiceArray[kTCCServiceLiverpool]="Location services"
ServiceArray[kTCCServiceUbiquity]="iCloud"
ServiceArray[kTCCServiceShareKit]="Share features"
ServiceArray[kTCCServiceLinkedIn]="Share via LinkedIn"
ServiceArray[kTCCServiceTwitter]="Share via Twitter"
ServiceArray[kTCCServiceFacebook]="Share via Facebook"
ServiceArray[kTCCServiceSinaWeibo]="Share via Sina Weibo"
ServiceArray[kTCCServiceTencentWeibo]="Share via Tencent Weibo"

# auth_reason 
typeset -A AuthReasonArray
AuthReasonArray[0]="Inherited/Unknown"
AuthReasonArray[1]="Error"
AuthReasonArray[2]="User Consent"
AuthReasonArray[3]="User Set"
AuthReasonArray[4]="System Set"
AuthReasonArray[5]="Service Policy"
AuthReasonArray[6]="MDM Policy"
AuthReasonArray[7]="Override Policy"
AuthReasonArray[8]="Missing usage string"
AuthReasonArray[9]="Prompt Timeout"
AuthReasonArray[10]="Preflight Unknown"
AuthReasonArray[11]="Entitled"
AuthReasonArray[12]="App Type Policy"

# auth_value
typeset -A AuthValueArray
AuthValueArray[0]="Denied"
AuthValueArray[1]="Unknown"
AuthValueArray[2]="Allowed"
AuthValueArray[3]="Limited"

CurrentClient=""
# gets a comma separated dump of the TCC db. 

sqlite3 /Library/Application\ Support/com.apple.tcc/tcc.db -csv -noheader -nullvalue '-' \
'select client, client_type, service, auth_value, auth_reason, last_modified from access order by client, auth_value' \
| while read -r TCCRow
do
  RawClient=$(echo $TCCRow | cut -d',' -f1)
  ClientType=$(echo $TCCRow | cut -d',' -f2)
  if [ $ClientType -eq 0 ]
  then
    Client=$(mdfind "kMDItemCFBundleIdentifier = $RawClient" | head -1)
    if [ -z $Client ]
    then
      Client=$RawClient
    fi
  else
    Client=$RawClient
  fi
  
  ServiceName=$(echo $TCCRow | cut -d',' -f3)
  AuthVal=$(echo $TCCRow | cut -d',' -f4)
  AuthReason=$(echo $TCCRow | cut -d',' -f5)
  DateAuthEpoch=$(echo $TCCRow | cut -d',' -f6)

  DateAuth=$(date -r $DateAuthEpoch +"%d %h, %Y")
  
  if [ "$Client" != "$CurrentClient" ]
  then
    CurrentClient=$Client
    printf "\nClient: %s:\n" $Client
    CurrentAuthVal=""
  fi
 
  if [ "$AuthVal" != "$CurrentAuthVal" ]
  then
    CurrentAuthVal=$AuthVal
    printf "\t%s:\n" $AuthValueArray[$AuthVal]
  fi
 
    printf "\t\t%s (%s - %s)\n\n"  $ServiceArray[$ServiceName] $AuthReasonArray[$AuthReason] $DateAuth
  
done
