#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

# List files to be deployed for debugging
ls -lh "$ARTIFACTS_DIR"/*

# Deploy to server using SCP (only from the `master` branch)
# `$SSH_PRIVATE_KEY` is a secret variable defined in the GitLab CI settings
if [[ "$CI_COMMIT_REF_NAME" == "master" ]]; then
  mkdir -p "$HOME/.ssh"
  echo "$SSH_PRIVATE_KEY" > "$HOME/.ssh/id_rsa"
  chmod 600 "$HOME/.ssh/id_rsa"
  cp "$CI_PROJECT_DIR/resources/known_hosts" "$HOME/.ssh/"
  scp -r "$ARTIFACTS_DIR"/* hugo@hugo.pro:/var/www/archive.hugo.pro/builds/godot/
fi
