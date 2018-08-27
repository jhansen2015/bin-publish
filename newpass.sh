#!/bin/bash

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
