#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

# Install dependencies
sudo apt-get update -qq
sudo apt-get install -qqq software-properties-common
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update -qq

sudo apt-get install -qqq git cmake zip unzip build-essential scons pkg-config \
    libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev libcairo2 \
    libglu-dev libasound2-dev libpulse-dev libfreetype6-dev \
    libssl-dev libudev-dev libxrandr-dev libxi-dev curl yasm expect \
    gcc-8 g++-8

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