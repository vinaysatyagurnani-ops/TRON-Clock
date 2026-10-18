# Tron Clock

A Grid-style timestamp for your MacBook in the format `MM:DD:YY:WD:HH:MM:SS:CS`
(WD = ISO weekday, Monday 01 to Sunday 07; CS = centiseconds), set in Michroma
with ENCOM blue-white light. When you touch a key the digits scramble into
`PASSWORD:`.

## Screensaver (the point of this)

```sh
xcode-select --install   # once, if you don't have the Command Line Tools
./build-saver.sh         # builds and installs ~/Library/Screen Savers/Tron Clock.saver
```

Then:

1. System Settings > Screen Saver > choose **Tron Clock**.
2. System Settings > Lock Screen > start screen saver when inactive, and
   require password **immediately** after the screen saver begins.

How the password morph works: when you move the mouse or press a key, macOS tells
the saver it is about to stop. The saver tells the page to morph the clock into
`PASSWORD:`. On macOS 14 and later the saver keeps rendering behind the system
login panel, so the text sits behind Apple's password field. The password field
itself is always Apple's; a third-party screensaver cannot replace the lock screen.
On older macOS the saver is torn down the instant you touch a key, so you may
never see the morph there.

Waking from sleep goes straight to the lock screen, not the screensaver. That is
how macOS works and no screensaver changes it.

## Window app

```sh
./build-app.sh
open "Tron Clock.app"
```

Ctrl-Cmd-F full screen, Cmd-Q quits. Any key shows the `PASSWORD:` morph, Esc
returns to the clock.

## Browser

Double-click `index.html`. Same keys as the app.

## Files

- `index.html`, `style.css`, `script.js`, `fonts/`: the clock itself.
- `macos/TronClockSaver.swift`: the ScreenSaverView, built by `build-saver.sh`.
- `macos/TronClock.swift`: the window app, built by `build-app.sh`.
