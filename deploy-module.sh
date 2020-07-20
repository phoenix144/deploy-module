#!/bin/bash
################################################################################
# NAME: deploy-module
# VERS: 0.1
# DESC: A tool to automate deployment of config modules via ssh. A module is
#       folder, containing the source files to transfer e.g. etc/<Service>.conf
#       and a pattern file, which holds  a filelist, deploy targets and
#       post-deployment commands.
# AUTH: Ferdinand Ellinger
###############################################################################


# Abort execution on errors
set -o errexit      # abort on nonzero exit status
set -o nounset      # abort on unset variable
set -o pipefail     # don't hide errors in pipes

# Definitions
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NOCOL='\033[0m'

readonly CWD=$(pwd)


# Checks arguments for right count or help options
#
help_wanted() {
    [ "$#" -ne "1" ] || [ "$1" = '-h' ] || [ "$1" = '--help' ] || [ "$1" = "-?" ]
    }

# Print usage message
#
usage() {
    cat << 'USAGE'
usage: $0 [OPTION] ... <Pattern file>
Deploys configuration modules to one or more remote hosts. The pattern file
holds data about files, targets and post-deployment commands.

	   $0 -h, --help        Display this help.
	   $0 -v                Display Script version.
USAGE
exit 0
}

# Handler for error trap
#
error_handler() {
    local exit_code=1

    # Disable the error trap handler to prevent potential recursion
    trap - ERR

    # Consider any further errors non-fatal to ensure we run to completion
    set +o errexit
    set +o pipefail

    # Validate provided exit code
    if [[ ${1-} =~ ^[0-9]+$ ]]; then
        exit_code="$1"
    fi

    echo -e "${NOCOL}An unexpected error occured. Stopping deployment."
    exit "$exit_code"
}
# Handler for exit trap
#
trap_exit() {
    # Restore original  working directory.
    cd "$CWD"
}

# Parse target for rdiff call
#
parse_target() {
    # trim trailing slashes
    target=$(echo "$1" | sed 's:/*$::')
    
    # check if directory and remove folder name
    if [ -d "$target" ]; then
        target="${target%/*}"
    fi

    # check if home dir
    if [ "${target%%/*}" == "home" ]; then
        target="~/""${target##*/}"
    else
    # if absolute path, add leading slash
        target="/""$target"
    fi
}


# Main control flow
#
#
trap error_handler ERR
trap trap_exit EXIT

# Initialize arrays and include pattern file to fill them
declare -a userlist
declare -a filelist
declare -a postcmd
declare target

source "$1"
cd "$(dirname "$1")"

# Check arguments and pattern file.
if help_wanted "$@"; then
    usage
fi

if ! [ -f "$1" ]; then
    echo "Pattern file doesn't exist or is not a regular file."
fi;


# Deployment process:
# Loop through targets
for user in "${userlist[@]}"; do
    echo -e "${GREEN}=== Connecting to ${BLUE} ${user#*@} ${GREEN} as user ${BLUE}${user%@*} ${GREEN}===${NOCOL}"

    # File deployment
    for file in "${filelist[@]}"; do
        parse_target "$file"
        echo rsync -zr -e ssh "${file}" "${user}":"$target"
    done

    # Post deployment commands
    if [ "${postcmd[0]}" != "'none'" ]; then
        for post_cmd in "${postcmd[@]}"; do
            echo -e "[Executing] ${post_cmd}"
            ssh -q "${user}" "${post_cmd}"
        done
    fi

    echo -e ""
done

echo -e "${GREEN}[Task finished] Deployed ${#filelist[@]} elements to ${#userlist[@]} targets.${NOCOL}"

exit 0
