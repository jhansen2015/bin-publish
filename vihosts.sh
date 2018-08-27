#!/bin/bash 

# Make sure we are running as root.
runas_admin.sh "$0" "$@" || exit

HOSTS_FILE="`cygpath 'c:\Windows\System32\Drivers\etc\hosts'`"
MD5=$(md5sum "$HOSTS_FILE")
vi "$HOSTS_FILE"
if [[ "$(md5sum "$HOSTS_FILE")" == "$MD5" ]]
then
	echo 'No changes; not flushing dns.'
else
	ipconfig /flushdns
fi

