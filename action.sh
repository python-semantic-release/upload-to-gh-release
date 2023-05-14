#!/bin/bash

set -e

# Copy inputs into correctly-named environment variables
export GH_TOKEN="${INPUT_GITHUB_TOKEN}"
export ROOT_OPTIONS="${INPUT_ROOT_OPTIONS:="-v"}"

# Change to configured directory
cd "${INPUT_DIRECTORY}"

# See https://github.com/actions/runner-images/issues/6775#issuecomment-1409268124
# and https://github.com/actions/runner-images/issues/6775#issuecomment-1410270956
git config --system --add safe.directory "*"

# Run Semantic Release
semantic-release ${ROOT_OPTIONS} publish --upload-to-vcs-release
