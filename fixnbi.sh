#!/bin/sh

# Set Server URL Var
SERVERURL="https://"`ifconfig | grep -A 1 en0 | grep netmask | awk '{print $2}'`":60443"

# Set Netboot Image Name
NETBOOTNBINAME=(DeployStudio_Lion DeployStudio_Yos)

if [ ! -d /Volumes/DeployStudioRuntime* ]; then


for i in "${NETBOOTNBINAME[@]}"
do

if [ ! -d /Library/NetBoot/NetBootSP0/$i.nbi ]; then

echo "$i does not seem to be correct, check for $i.nbi and try again"

else

# Mount Desired Netboot Image
hdiutil attach /Library/NetBoot/NetBootSP0/$i.nbi/NetInstall.sparseimage

# Print Existing URL
echo "Existing URL:"
/usr/libexec/PlistBuddy -c "Print :server:url" /Volumes/DeployStudioRuntime/Library/Preferences/com.deploystudio.server.plist

# Set Server URL in Pref File
/usr/libexec/PlistBuddy -c "Set :server:url $SERVERURL" /Volumes/DeployStudioRuntime/Library/Preferences/com.deploystudio.server.plist

# Print New URL
echo "New URL:"
/usr/libexec/PlistBuddy -c "Print :server:url" /Volumes/DeployStudioRuntime/Library/Preferences/com.deploystudio.server.plist

# Unmount Netboot Image
while [ -e /Volumes/DeployStudioRuntime ]
do
sleep 30
hdiutil detach /Volumes/DeployStudioRuntime
done

# Make sure nbi names are correct
/usr/libexec/PlistBuddy -c "Print :Name" /Library/NetBoot/NetBootSP0/$i.nbi/NBImageInfo.plist
/usr/libexec/PlistBuddy -c "Set :Name $i" /Library/NetBoot/NetBootSP0/$i.nbi/NBImageInfo.plist
/usr/libexec/PlistBuddy -c "Print :Name" /Library/NetBoot/NetBootSP0/$i.nbi/NBImageInfo.plist

fi

done

# Restart DeployStudio
"/Applications/Utilities/DeployStudio Admin.app/Contents/sbin/DeployStudioServerEnabler" -stop
"/Applications/Utilities/DeployStudio Admin.app/Contents/sbin/DeployStudioServerEnabler" -start

else

echo "Eject DeployStudioRuntime and try again"
exit 1

fi



