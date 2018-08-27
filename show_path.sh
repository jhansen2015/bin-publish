#!/bin/bash

function show_path() {

	local IFS=$'\n'
	declare -A EXISTS=()
	local p
	# Convert entries to an array
	for p in `printf "${PATH//:/$IFS}"`
	do
		if [[ -v EXISTS["$p"] ]]
		then
			echo '# DUPLICATE:'
		else
			EXISTS["$p"]=1
		fi

		if [[ ! -d "$p" ]]
		then
			echo '# MISSING:'
		fi
		echo "$p"
	done

}

show_path
