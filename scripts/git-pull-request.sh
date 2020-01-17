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

if [ -z "${GITHUB_REPO_OWNER}" ]; then
    GITHUB_REPO_OWNER="microsoft"
fi
GITHUB_REPO_NAME="appcenter-sdk-dotnet"
REQUEST_URL_PULL="https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/pulls?access_token=$github_access_token"

resp="$(curl -s -X POST $REQUEST_URL_PULL -d '{
      "title": "Start new '${SDK_NEW_VERSION}' version",
      "body": "Start new '${SDK_NEW_VERSION}' version",
      "head": "release/'${SDK_NEW_VERSION}",
      "base": "master"
    }')"
url="$(echo $resp | jq -r '.url')"

if [ -z $url ] || [ "$url" == "" ] || [ "$url" == "null" ]; then
    echo "Cannot create a pull request"
    echo "Response:" $url
else
    echo "A pull request has been created at $url"
fi

exit 1
