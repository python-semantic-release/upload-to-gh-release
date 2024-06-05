#!/bin/bash

set -e

explicit_run_cmd() {
  local cmd="$*"
  printf '%s\n' "$> $cmd"
  eval "$cmd"
}

# See https://github.com/actions/runner-images/issues/6775#issuecomment-1409268124
# and https://github.com/actions/runner-images/issues/6775#issuecomment-1410270956
git config --system --add safe.directory "*"

# Change to configured directory
cd "${INPUT_DIRECTORY}"

# Make Token available as a correctly-named environment variables
export GH_TOKEN="${INPUT_GITHUB_TOKEN}"

# Bash array to store publish arguments
PUBLISH_ARGS=()

# Add publish arguments as necessary
if [ -n "${INPUT_TAG}" ]; then
  PUBLISH_ARGS+=("--tag ${INPUT_TAG}")
fi

# Run Semantic Release
explicit_run_cmd "$PSR_VENV_BIN/semantic-release ${INPUT_ROOT_OPTIONS} publish ${PUBLISH_ARGS[*]}"
