import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    // Phone-sized logical frame for mobile UI testing; window stays resizable.
    self.setFrame(
      NSRect(x: windowFrame.origin.x, y: windowFrame.origin.y, width: 420, height: 910),
      display: true,
    )

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
