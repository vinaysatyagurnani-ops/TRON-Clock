# Tron Clock

A Grid-style timestamp for your MacBook, in the format `MM:DD:YY:WD:HH:MM:SS:CS`
(WD = ISO weekday, Monday 01 to Sunday 07; CS = centiseconds).

## Quickest: open in a browser

Double-click `index.html`, then hit full screen (Ctrl-Cmd-F in Safari/Chrome).

## Native app

```sh
xcode-select --install   # once, if you don't have the Command Line Tools
./build-app.sh
open "Tron Clock.app"
```

Ctrl-Cmd-F toggles full screen, Cmd-Q quits. Drag the app to `/Applications`
if you want it in Launchpad, or add it to System Settings > General > Login Items
to start it with your Mac.

## Files

- `index.html`, `style.css`, `script.js`: the clock itself.
- `macos/TronClock.swift`: a WKWebView wrapper, compiled by `build-app.sh`.
