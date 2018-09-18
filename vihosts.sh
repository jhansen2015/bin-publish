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

