// macOS screen saver: a WKWebView showing the Tron clock.
// When macOS signals the saver is about to stop (you touched a key or the trackpad),
// the digits morph into PASSWORD:. On macOS 14+ the saver keeps rendering behind the
// system login panel, so that text sits behind Apple's password field.
import ScreenSaver
import WebKit

@objc(TronClockView)
final class TronClockView: ScreenSaverView {
    private var webView: WKWebView!

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.cgColor
        animationTimeInterval = 1.0 / 30.0

        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: bounds, configuration: config)
        webView.autoresizingMask = [.width, .height]
        webView.setValue(false, forKey: "drawsBackground")

        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: "index", withExtension: "html", subdirectory: "web") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            NSLog("Tron Clock saver: web/index.html missing from bundle")
        }
        addSubview(webView)

        let center = DistributedNotificationCenter.default()
        center.addObserver(self, selector: #selector(saverWillStop),
                           name: Notification.Name("com.apple.screensaver.willstop"), object: nil)
        center.addObserver(self, selector: #selector(saverDidStart),
                           name: Notification.Name("com.apple.screensaver.didstart"), object: nil)
        center.addObserver(self, selector: #selector(saverDidStart),
                           name: Notification.Name("com.apple.screenIsUnlocked"), object: nil)
    }

    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }

    @objc private func saverWillStop() {
        webView.evaluateJavaScript("window.tron && window.tron.showPassword()", completionHandler: nil)
    }

    @objc private func saverDidStart() {
        webView.evaluateJavaScript("window.tron && window.tron.showClock()", completionHandler: nil)
    }

    override var hasConfigureSheet: Bool { false }
    override var configureSheet: NSWindow? { nil }

    // The page animates itself with requestAnimationFrame; nothing to draw here.
    override func animateOneFrame() {}
}
