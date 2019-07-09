#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export ANDROID_NDK_ROOT=$ANDROID_HOME/ndk-bundle

# Build Android export template
for target in "release_debug" "release"; do
  for arch in "armv7" "arm64v8" "x86"; do
  scons platform=android tools=no target="$target" android_arch="$SCONS_ARCH" \
        "${SCONS_FLAGS[@]}" "${SCONS_TMPL_FLAGS[@]}"
  done
done

# Create an APK and move it to the artifacts directory
cd "$GODOT_DIR/platform/android/java/"
./gradlew build
for target in "debug" "release"; do
  mv "$GODOT_DIR/bin/android_$target.apk" \
      "$BUILD_ARTIFACTSTAGINGDIRECTORY/templates/"
done