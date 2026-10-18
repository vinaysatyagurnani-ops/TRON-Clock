#!/usr/bin/env bash
# Builds "Tron Clock.app" in this directory. Requires Xcode Command Line Tools:
#   xcode-select --install
set -euo pipefail
cd "$(dirname "$0")"

APP="Tron Clock.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources/web/fonts"

swiftc -O -o "$APP/Contents/MacOS/TronClock" macos/TronClock.swift \
  -framework Cocoa -framework WebKit

cp index.html style.css script.js "$APP/Contents/Resources/web/"
cp fonts/Michroma-Regular.ttf "$APP/Contents/Resources/web/fonts/"
cp macos/Info.plist "$APP/Contents/Info.plist"

# Ad-hoc signature so Gatekeeper lets a locally built app launch.
codesign --force --sign - "$APP" >/dev/null 2>&1 || true

echo "Built: $PWD/$APP"
echo "Run:   open \"$APP\"   (Ctrl-Cmd-F for full screen, Cmd-Q to quit)"
