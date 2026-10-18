#!/usr/bin/env bash
# Builds and installs "Tron Clock.saver" into ~/Library/Screen Savers.
# Requires Xcode Command Line Tools:  xcode-select --install
set -euo pipefail
cd "$(dirname "$0")"

SAVER="Tron Clock.saver"
rm -rf "./${SAVER:?}"
mkdir -p "$SAVER/Contents/MacOS" "$SAVER/Contents/Resources/web/fonts"

swiftc -O -emit-library -module-name TronClockSaver \
  -o "$SAVER/Contents/MacOS/TronClockSaver" macos/TronClockSaver.swift \
  -framework ScreenSaver -framework WebKit

cp index.html style.css script.js "$SAVER/Contents/Resources/web/"
cp fonts/Michroma-Regular.ttf "$SAVER/Contents/Resources/web/fonts/"
cp macos/Saver-Info.plist "$SAVER/Contents/Info.plist"
codesign --force --sign - "$SAVER" >/dev/null 2>&1 || true

DEST="${HOME:?}/Library/Screen Savers"
mkdir -p "$DEST"
rm -rf "${DEST:?}/${SAVER:?}"
cp -R "$SAVER" "$DEST/"

# System Settings caches the saver list; kick the host so the new build is picked up.
killall legacyScreenSaver 2>/dev/null || true
killall "System Settings" 2>/dev/null || true

echo "Installed: $DEST/$SAVER"
echo "Now: System Settings > Screen Saver > pick Tron Clock."
echo "Then: System Settings > Lock Screen > start screen saver when inactive, require password immediately."
