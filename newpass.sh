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

# '!' is beginning of printable character range
# '~' is end of printable character range
# https://www.asciitable.com/
# https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/

for ((i=1; i<=10; ++i))
do

	#P="`tr -dc '[:alnum:]!@#$%^&*+=.?,' < /dev/urandom | head -c12; echo ""`"
	P="`tr -dc '[:alnum:].@$*&!#' < /dev/urandom | head -c12; echo ""`"
	if ! [[ $P =~ [A-Z] ]]
	then
		#echo '  No uppercase letter!'
		invalid=1
	fi

	if ! [[ $P =~ [0-9] ]]
	then
		#echo '  No number!'
		invalid=1
	fi

	if ! [[ $P =~ [!@#$%^\&*+=\.\?,] ]]
	then
		#echo '  No special character!'
		invalid=1
	fi

	if [[ -v $invalid ]]
	then
		$[--i]
		continue
	fi

	echo "$P"
done
