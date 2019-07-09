#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

choco install 7zip

pip install scons

git clone --depth=1 --branch "$GODOT_REPO_BRANCH" "$GODOT_REPO_URL"
mkdir -p \
    "$BUILD_ARTIFACTSTAGINGDIRECTORY/editor" \
    "$BUILD_ARTIFACTSTAGINGDIRECTORY/templates"

# Prepare submodules for integration
for module_dir in $(ls staging)
do
    cp -rv staging/$module_dir/$module_dir modules
done

# Copy user-supplied modules into the Godot directory
# (don't fail in case no modules are present)
cp -rv "modules"/* "godot/modules/" || true

# Print information about the commit to build
printf -- "-%.0s" {0..72}
echo ""
git -C "godot/" log --max-count 1
printf -- "-%.0s" {0..72}
echo ""

chmod +x scripts/azure-pipelines/build/*.sh