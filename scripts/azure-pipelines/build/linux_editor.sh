#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

# Build Linux editor
scons platform=x11 tools=yes target=release_debug \
      udev=yes use_static_cpp=yes \
      LINKFLAGS="-fuse-ld=gold" \
      "${SCONS_FLAGS[@]}"

# Create Linux editor AppImage
strip "bin/godot.x11.opt.tools.64"
mkdir -p "appdir/usr/bin/" "appdir/usr/share/icons"
cp "bin/godot.x11.opt.tools.64" "appdir/usr/bin/godot"
cp "misc/dist/linux/org.godotengine.Godot.desktop" "appdir/godot.desktop"
cp "icon.svg" "appdir/usr/share/icons/godot.svg"
curl -fsSLO "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod +x "linuxdeployqt-continuous-x86_64.AppImage"
./linuxdeployqt-continuous-x86_64.AppImage \
    --appimage-extract-and-run \
    "appdir/godot.desktop" -appimage

mv \
    "Godot_Engine-"*"-x86_64.AppImage" \
    "$BUILD_ARTIFACTSTAGINGDIRECTORY/editor/godot-linux-nightly-x86_64.AppImage"
