#!/bin/bash

# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

help() {
  echo "Usage: $0 -t <github-access-token>"
}

shift
github_access_token=""

while getopts 't:' flag; do
  case "${flag}" in
    t)
      github_access_token=${OPTARG}
      ;;
    *)
      help
      exit 1
      ;;
  esac
done

if [ "$github_access_token" == "" ]; then
  help
  exit 1
fi

git config --global url."https://api:$github_access_token@github.com/".insteadOf "https://github.com/"
git config --global url."https://ssh:$github_access_token@github.com/".insteadOf "ssh://git@github.com/"
git config --global url."https://git:$github_access_token@github.com/".insteadOf "git@github.com:"