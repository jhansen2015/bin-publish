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

if [[ "$1" == "--help" ]]
then
	echo "USAGE: `basename "$0"` [--help]
v1.0

Features:
* Invokes 'difftool --dir-diff --no-symlinks --cached'
* Default is to not commit; provides a 'REMOTE THIS LINE' option to commit.
* Cancelled messages are retained, then loaded on next attempt
* Provides porcelain v2 output in message
* Cancels if changes are detected to 'git status', 'git status --porcelain=2', staged, or unstaged files.
* Worktree aware
* Removes commit message file on successful commit

Options
--help   Prints this message
"
	exit 1
fi

if ! GIT_ROOT="`git rev-parse --show-toplevel`"
then
	exit 1
fi

cd "$GIT_ROOT"

if [[ -z "`git diff --cached`" ]]
then
	echo "No changes have been staged; nothing to commit.  Cancelling."
	git status
	exit 1
fi

git difftool --dir-diff --no-symlinks --cached >/dev/null 2>&1 &
DIFF_PID=$!

function computeHash() {
	{
		# Catch new or deleted untracked files
		git status
		git status --porcelain=2

		# Catch changes in staged files
		git diff --cached

		# Catch changes to non-staged files
		git diff

	} | md5sum
}

#
# We do not use COMMIT_EDITMSG. While git writes to it by default,
# it does not read it on next commit attempt, and will overwrite it.
#
if [[ -d ".git" ]]
then
	GIT_LOG=".git/commit_msg"
else
	# Worktree aware
	read junk GIT_WORKTREE_BASE <.git
	GIT_LOG="$GIT_WORKTREE_BASE/commit_msg"
fi

if [[ ! -s "$GIT_LOG" ]]
then
	echo "" > "$GIT_LOG"
fi

#
# Generate the hash so we can cancel the commit if files have changed
#
OLD_HASH="$(computeHash)"

# Delete comments/ info from previous execution
sed -i '/^#/d' "$GIT_LOG"

# Check if the last line in empty; if not, add a carriage return
if [[ ! -z "`tail -n 1 "$GIT_LOG"`" ]]
then
	echo "" >> "$GIT_LOG"
fi

REMOVE_LINE="# REMOVE THIS LINE TO COMMIT"
echo "#
$REMOVE_LINE
#" >> $GIT_LOG

{
	git status

	echo "git status --porcelain=2:"
	git status --porcelain=2

} | sed 's/^/# /' >> "$GIT_LOG"

# TODO: syntax gitcommit
vim -c 'set syntax=gitcommit' "$GIT_LOG"

# Wait for difftool to complete
# Ideally, we would kill the process, but there are several subprocesses,
# and they don't seem to die (in Windows) when the parent is killed.
if /bin/kill -0 $DIFF_PID >/dev/null 2>&1 
then
	echo "Waiting for difftool to exit..."
	wait $DIFF_PID
fi

if grep "$REMOVE_LINE" "$GIT_LOG" >/dev/null
then
	echo "Commit cancelled. Commit message saved in $GIT_ROOT/$GIT_LOG"
	exit 1
fi

# Delete comments/ info before actual commit
sed -i '/^#/d' "$GIT_LOG"

# Check the hash
NEW_HASH="$(computeHash)"
if [[ "$NEW_HASH" != "$OLD_HASH" ]]
then
	echo "Changes to status, staged, or unstaged files detected; cancelling. Commit message saved in $GIT_ROOT/$GIT_LOG"
	exit 1
fi

# Do the actual commit
if git commit -F "$GIT_LOG"
then
	if [[ -e "$GIT_LOG" ]]
	then
		rm "$GIT_LOG"
	fi
fi

