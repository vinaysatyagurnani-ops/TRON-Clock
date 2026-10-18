// Minimal native macOS shell around the web clock: a black window hosting a WKWebView.
// Build with ./build-app.sh (needs Xcode Command Line Tools for swiftc).
import Cocoa
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let rect = NSRect(x: 0, y: 0, width: 1000, height: 320)
        window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Tron Clock"
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.backgroundColor = .black
        window.collectionBehavior = [.fullScreenPrimary]
        window.center()
        window.setFrameAutosaveName("TronClockMain")

        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: window.contentView!.bounds, configuration: config)
        webView.autoresizingMask = [.width, .height]
        webView.setValue(false, forKey: "drawsBackground")

        guard let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "web") else {
            NSLog("Tron Clock: web/index.html missing from bundle")
            NSApp.terminate(nil)
            return
        }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        window.contentView!.addSubview(webView)

        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)

// Menu bar: just enough for Cmd-Q and Ctrl-Cmd-F to work.
let mainMenu = NSMenu()
let appMenuItem = NSMenuItem()
mainMenu.addItem(appMenuItem)
let appMenu = NSMenu()
let fullScreenItem = NSMenuItem(
    title: "Toggle Full Screen",
    action: #selector(NSWindow.toggleFullScreen(_:)),
    keyEquivalent: "f"
)
fullScreenItem.keyEquivalentModifierMask = [.command, .control]
appMenu.addItem(fullScreenItem)
appMenu.addItem(NSMenuItem.separator())
appMenu.addItem(withTitle: "Quit Tron Clock", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
appMenuItem.submenu = appMenu
app.mainMenu = mainMenu

app.run()
