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

function help {
    printf "Usage: ./run.sh task [argument ...]\n"
    printf "\n"
    printf "\tRun a project specific task with optional arguments."
    printf "\n"
    printf "\ttask: spellcheck, help\n"
}

function spellcheck {
    # Use the pyspelling command to check for spelling issues in this project.
    # See: https://facelessuser.github.io/pyspelling/
    pyspelling "$@"
}


# If no task provided, run the help task, exit with no error
if [[ $# == 0 ]]; then
    help
    exit 0
fi

# If invalid task provided, show error and then run the help task, exit with error
if ! declare -F "$1" > /dev/null; then
    printf "Error: %s is an invalid task!\n\n" "$1"
    help
    exit 1
fi

# Dispatch the task
"$@"
