#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

scons platform=iphone arch=x86_64 tools=no target=release_debug \
      "${SCONS_FLAGS[@]}" "${SCONS_TMPL_FLAGS[@]}"

# Create export templates ZIP archive
mv "bin/libgodot.iphone.opt.debug.x86_64.a" "libgodot.iphone.opt.debug.simulator.a"
touch "data.pck"
zip -r9 \
    "$BUILD_ARTIFACTSTAGINGDIRECTORY/templates/simulator.zip" \
    "libgodot.iphone.opt.debug.simulator.a" \
    "data.pck"
