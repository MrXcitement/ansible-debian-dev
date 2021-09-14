#!/bin/bash

# run.sh - Project specific tasks
# Use this script for all project tasks to simplify any and all tasks for this
# project. Additionaly this script will provide a central place to document all
# the unique tasks that this project uses.

# Inspiration:
# See https://death.andgravity.com/run-sh
# for an explanation of how it works and why it's useful.

# Mike Barker <mike@thebarkers.com>
# August 17th, 2021

set -o nounset
set -o pipefail
set -o errexit

# An array of help strings in the format of task:help
# An entry in this array must exist for the function to be runable.
declare -a TASK_HELP

# Change the current directory to the project root.
PROJECT_ROOT=${0%/*}
if [[ $0 != $PROJECT_ROOT && $PROJECT_ROOT != "" ]]; then
    pushd "$PROJECT_ROOT" > /dev/null
fi
readonly PROJECT_ROOT=$( pwd )
readonly SCRIPT_NAME=${0##*/}

# Store the absolute path to this script (useful for recursion).
readonly SCRIPT="$PROJECT_ROOT/$SCRIPT_NAME"

# Display help for the run.sh script
TASK_HELP+=("help:Display the help")
function help {
    printf "usage: ./run.sh <task> [argument ...]\n"
    printf "\n"
    printf "These are the valid tasks that can be run.\n"
    printf "\n"
    for item in "${TASK_HELP[@]}"; do
        IFS=':' read -r -a fields <<< "$item"
        printf "%-24s%s\n" "${fields[0]}" "${fields[1]}"
    done
    printf "\n"
}

# Source the Runfile to get the run tasks
if [[ -f ./Runfile ]]; then
    source ./Runfile
fi

# Check for no arguments
if [[ $# -eq 0 ]]; then
    help
    popd > /dev/null
    exit 1
fi

# Check for undefined task
if ! [[ "${TASK_HELP[*]}" =~ "$1:" ]]; then
    # Undefined task specified
    printf "Error! '%s' is an undefined task!\n" "$1"
    popd > /dev/null
    exit 1
fi

# Dispatch the task
TIMEFORMAT="Task completed in %3lR"
time "$@"

# Cleanup and exit
popd > /dev/null
exit 0
