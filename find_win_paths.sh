#!/bin/bash
########################################
# Search (my) common windows paths for '.exe' files.
# Convenient way to find out specific install paths for applications
# in subdirectories
########################################

APP_DIRS+=( \
	"/cygdrive/c/A32" \
	"/cygdrive/c/A64" \
	"/cygdrive/c/Apps" \
	"/cygdrive/c/Apps-32bit" \
	"/cygdrive/c/Apps-64bit" \
	"/cygdrive/c/Program Files" \
	"/cygdrive/c/Program Files (x86)" \
)

#
# Make sure each directory exists.
#
DIRS=()
for d in "${APP_DIRS[@]}"
do
	if [[ -d "$d" ]]
	then
		DIRS+=( "$d" )
	fi
done

find "${DIRS[@]}" -regex '.*.exe$' | sed 's/\/[^/]*$//' | grep -v uninst | sort | uniq -c 

