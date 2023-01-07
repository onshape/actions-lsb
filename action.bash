#!/bin/bash

set -o errexit
set -o pipefail
set -o xtrace

[[ $(uname) == "Darwin" ]] && export PATH=/usr/local/bin:$PATH

operation=$1
ownerRepo=$2
workflowBranch=$3
putLsb=$4
putVersionWithBuild=$5
expiryMons=$6

lsb=''
versionWithBuild=''

if [[ "${operation}" == "get" ]]; then
    keyFormat='{ "repo": { "S": "%s" }, "workflowBranch": { "S": "%s" } }'
    # shellcheck disable=SC2059
    keyData=$(printf "${keyFormat}" "${ownerRepo}" "${workflowBranch}")
    read -r lsb versionWithBuild <<< "$(aws dynamodb get-item --table-name "${TABLE_NAME}" --key "${keyData}" | jq -r '.Item.lsb.S + " " + .Item.versionWithBuild.S')"
elif [[ "${operation}" == "put" ]]; then
    if [[ "${putLsb}" == "" ]]; then
        echo "Error: putLsb is unset"
        exit 1
    fi
    if [[ "${putVersionWithBuild}" == "" ]]; then
        echo "Error: putVersionWithBuild is unset"
        exit 1
    fi
    seconds=$((expiryMons * 31 * 24 * 60 * 60))
    expires=$(($(date +%s) + seconds))

    itemFormat='{ "repo": { "S": "%s" }, "workflowBranch": { "S": "%s" }, "lsb": { "S": "%s" }, "versionWithBuild": { "S": "%s" }, "expires": { "N": "%s" } }'
    # shellcheck disable=SC2059
    itemData=$(printf "${itemFormat}" "${ownerRepo}" "${workflowBranch}" "${putLsb}" "${putVersionWithBuild}" "${expires}")
    aws dynamodb put-item --table-name "${TABLE_NAME}" --item "${itemData}"
else
    echo "Error: unrecognised operation '${operation}'"
    exit 1
fi
echo "value=${lsb}" >> $GITHUB_OUTPUT
echo "version_with_build=${versionWithBuild}" >> $GITHUB_OUTPUT
