#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

# # Install the Android SDK
# mkdir -p "$BUILD_REPOSITORY_LOCALPATH/android"
# cd "$BUILD_REPOSITORY_LOCALPATH/android"
# curl -fsSLO "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
# unzip -q sdk-tools-linux-*.zip
# rm sdk-tools-linux-*.zip
# export ANDROID_HOME="$BUILD_REPOSITORY_LOCALPATH/android"

# # Install Android SDK components
# mkdir -p "$HOME/.android"
# echo "count=0" > "$HOME/.android/repositories.cfg"
# /usr/bin/expect -c '
#     set timeout -1;
#     spawn '"${ANDROID_HOME}"'/tools/bin/sdkmanager --licenses;
#     expect {
#         "y/N" { exp_send "y\r" ; exp_continue }
#         eof
#     }
#     '
# echo "Install Android Tools"
# "$ANDROID_HOME/tools/bin/sdkmanager" "tools" "platform-tools" "build-tools;28.0.3"

# # Install the Android NDK
# echo "Android NDK"
# curl -fsSLO "https://dl.google.com/android/repository/android-ndk-r19-linux-x86_64.zip"
# echo "Extract NDK"
# unzip -q android-ndk-*-linux-x86_64.zip
# rm android-ndk-*-linux-x86_64.zip
# mv ./*ndk* ndk/
# export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk"

# cd $BUILD_REPOSITORY_LOCALPATH

export ANDROID_NDK_ROOT=$ANDROID_HOME/ndk-bundle

# Build Android export template
for target in "release_debug" "release"; do
  for arch in "armv7" "arm64v8" "x86"; do
  scons platform=android tools=no target="$target" android_arch="$arch" \
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