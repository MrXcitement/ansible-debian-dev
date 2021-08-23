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
    printf "usage: ./run.sh <task> [argument ...]\n"
    printf "\n"
    printf "These are the valid tasks that can be run.\n"
    printf "\n"
    printf "\thelp\t\t\tShow this help\n"
    printf "\tspellcheck\t\tRun a spellcheck of files in the project\n"
    printf "\tvagrant-dev\t\tinstall the prerequisites and run the playbook in the vagrant box\n"
    printf "\tvagrant-fix-vmware\tFix macOS vagrant vmware plugin\n"
    printf "\n"
}

function playbook {
	ansible-playbook -K ./playbook.yml
}

function prerequisites {
	sudo apt install -y ansible
}

function spellcheck {
    # Use the pyspelling command to check for spelling issues in this project.
    # See: https://facelessuser.github.io/pyspelling/
    pyspelling "$@"
}

function vagrant-dev {
    vagrant ssh -c "cd /vagrant && ./run.sh prerequisites && ./run.sh playbook && exit"
}

# See: https://github.com/hashicorp/vagrant/issues/11839
function vagrant-fix-vmware {
    sudo launchctl stop com.vagrant.vagrant-vmware-utility
    sudo launchctl start com.vagrant.vagrant-vmware-utility
}

# If no task provided, run the help task, exit with no error
if [[ $# == 0 ]]; then
    help
    exit 0
fi

# If invalid task provided, show error and then run the help task, exit with error
if ! declare -F "$1" > /dev/null; then
    printf "Error! %s is an invalid task!\n\n" "$1"
    help
    exit 1
fi

# Dispatch the task
"$@"
