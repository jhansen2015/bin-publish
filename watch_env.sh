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

function compare_env_cd3b4a9a3f74458e9f535b10bbdb2161() {

	# Check dependencies
	# 
	local c
	for c in mktemp rm diff "${DIFFTOOL:-diff}"
	do
		if ! type "$c" >/dev/null
		then
			return
		fi
	done
	
	# Save environment to make sure we cleaned up correctly.
	local set_1="`mktemp -t set.1.XXXXX`"
	local set_2
	set_2="`mktemp -t set.2.XXXXX`"
	set > "$set_1"
	
	#
	# Call the script to watch here
	#
	. "$@" || true
	
	#
	# Dump our environment to do a comparison
	#
	# Set the $_ to match value when earlier 'set' was called.
	set_2="$set_2"
	set > "$set_2"
	
	# Do an actual diff
	if ! diff "$set_1" "$set_2" >/dev/null
	then
		echo "Changes detected."
		"${DIFFTOOL:-diff}" "$set_1" "$set_2"
	fi
	rm "$set_1" "$set_2"

}

if [[ $# -eq 0 ]]
then
	echo "USAGE: $0 cmd [cmd_args]
Compare the env before and after running: cmd [cmd_args]
"
else
	compare_env_cd3b4a9a3f74458e9f535b10bbdb2161 "$@"
	unset -f compare_env_cd3b4a9a3f74458e9f535b10bbdb2161
fi

