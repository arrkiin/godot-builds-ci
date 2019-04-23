#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

# Install dependencies and upgrade to Bash 4
brew update
brew install bash scons yasm
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
sudo chsh -s "$(brew --prefix)/bin/bash"
"$(brew --prefix)/bin/bash" -c "cd $PWD"
git clone --depth=1 --branch "$GODOT_REPO_BRANCH" "$GODOT_REPO_URL"
mkdir -p \
    "$BUILD_ARTIFACTSTAGINGDIRECTORY/editor" \
    "$BUILD_ARTIFACTSTAGINGDIRECTORY/templates"

# Prepare submodules for integration
for module_dir in $(ls staging)
do
    cp -r staging/$module_dir/$module_dir modules
done

# Provide Admob iOS sdk
mkdir -p tmp
cd tmp
curl -LO http://dl.google.com/googleadmobadssdk/googlemobileadssdkios.zip
unzip googlemobileadssdkios.zip
for sdk_dir in GoogleMobileAdsSdkiOS*/ ; do
    for lib_dir in ./$sdk_dir/*.framework; do
        cp -r $lib_dir modules/admob/ios/lib
    done
done
cd ..

# Copy user-supplied modules into the Godot directory
# (don't fail in case no modules are present)
cp -r "modules"/* "godot/modules/" || true

# Print information about the commit to build
printf -- "-%.0s" {0..72}
echo ""
git -C "godot/" log --max-count 1
printf -- "-%.0s" {0..72}
echo ""
