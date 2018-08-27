#!/bin/bash

if [[ "--help" == "$1" ]]
then
	echo "USAGE: $0 [--help] [cmd] [args]
Executes the given command as Administrator.

--help   This message
no args  Run: /bin/bash -li

Example:
\$ runas_admin.sh vihosts.sh

In a script, so script doesn't continue running if not an admin.
$0 \"\$0\" \"\$@\" || exit

"
	exit 1
fi

if ! net session > /dev/null 2>&1
then
	# Complicated:
	# mintty -h always : keeps the window open after command finishes.
	# bash -li : allows .bashrc to be sourced so we get a full path
	cygstart --action=runas "`cygpath 'C:\cygwin64\bin\mintty.exe'`" -i "/Cygwin-Terminal.ico" -h always -e /bin/bash -li "$@"
	exit 1
fi
exit 0
