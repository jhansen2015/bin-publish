#!/bin/bash

##########################################################################
#
# Copyright 2018 Joshua Hansen
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
##########################################################################

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
