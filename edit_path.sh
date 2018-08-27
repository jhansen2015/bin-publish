#!/bin/bash

#
# If there is no mktemp; give up.
# Make sure we clean up files when we are done.
#
if ! type mktemp >/dev/null
then
	return
fi

function show_path_parts_d5b29c18024c4e1489bb971f0ddf5a6f() {

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

#
# Create as a function so we can use local variables.
# Name created with `uuidgen | sed 's/-//g'
#
function edit_path_d5b29c18024c4e1489bb971f0ddf5a6f() {

	local EDITOR="${EDITOR:-vim}"
	# Check dependencies
	local cmd
	for cmd in printf sed "$EDITOR"
	do
		if ! type $cmd >/dev/null
		then
			echo "Cannot find cmd=[$cmd]"
			return
		fi
	done

	# Extra features
	for cmd in cygpath
	do
		if type $cmd >/dev/null 2>&1
		then
			local HAS_$cmd=1
		fi
	done

	local WRITE_CHECK='# DELETE THIS LINE TO SAVE CHANGES' 
	printf "#\n$WRITE_CHECK\n#\n" > "$TMP_FILE" || return 
	
	show_path_parts_d5b29c18024c4e1489bb971f0ddf5a6f >> "$TMP_FILE"

	# Vim: to exit with error code: ":cq"
	if ! "$EDITOR" "$TMP_FILE"
	then
		echo "Cancelled."
		return
	fi

	# Slurp the results in as an array
	local IFS=$'\n'
	local P
	P=( `sed 's/\s\+$//' "$TMP_FILE"` ) || return

	# Join the elements of the array
	local NEW_PATH=""
	local p
	for p in "${P[@]}"
	do
		# Was it cancelled?
		if [[ "$p" == "$WRITE_CHECK" ]]
		then
			echo "Cancelled."
			return
		fi

		case "$p" in
		'#'|'# MISSING:'|'# DUPLICATE:')
			continue
			;;
		esac

		# Auto-convert cygwin paths
		if [[ -v HAS_cygpath ]]
		then
			p="`cygpath "$p"`"
		fi

		NEW_PATH="$NEW_PATH:$p"

	done

	# Remove the leading ':'
	export PATH="${NEW_PATH:1}"

	echo 'Path entries:
----------------'
	show_path_parts_d5b29c18024c4e1489bb971f0ddf5a6f
	echo '----------------'

	echo "PATH=${PATH}"
	
}


if TMP_FILE="`mktemp -t PATH.XXXXX`"
then
	edit_path_d5b29c18024c4e1489bb971f0ddf5a6f
	rm "$TMP_FILE"
	unset TMP_FILE
fi

# Clean up after ourselves.
unset -f edit_path_d5b29c18024c4e1489bb971f0ddf5a6f
unset -f show_path_parts_d5b29c18024c4e1489bb971f0ddf5a6f
