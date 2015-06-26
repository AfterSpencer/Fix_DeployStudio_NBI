# Fix DeployStudio NBI
Scipt for fixing DeployStudio NBI when moving from one server to another.

This script finds the IP address of en0 then sets the Server URL to match in the DeployStudio Netboot Image's on the server.

If the active IP address is on a different ethernet port change line 4 to match - change en0 to en1, for example. It is also assumed that SSL is used, if not make the appropriate change on line 4. I beleive this should work assuming default port is used:
```
SERVERURL="http://"`ifconfig | grep -A 1 en0 | grep netmask | awk '{print $2}'`":60080"
```
The script also accepts a list of NBIs in line 7. Change the items in the array to match the images under /Library/NetBoot/NetbootSP0.

The script will check to make sure the items exist before trying to fix them. It also displays the old setting and the new setting. 

Once it has made the change it will restart the DeployStudio service.
