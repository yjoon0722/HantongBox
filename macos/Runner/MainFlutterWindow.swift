import Cocoa
import FlutterMacOS
import WidgetKit

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
/*
    let lastTimeChannel = FlutterMethodChannel(name: "hantongbox.save/lastTime", binaryMessenger: flutterViewController.engine.binaryMessenger)
    debugPrint("lastTimeChannel OK(MainFlutterWindow)")
    lastTimeChannel.setMethodCallHandler { (call, result) in
        debugPrint("setMethodCallHandler init(MainFlutterWindow)")
        debugPrint("native- setMethodCallHandler(MainFlutterWindow)")
        guard call.method == "setLastTime" else {
            result(FlutterMethodNotImplemented)
            return
        }

        if let args = call.arguments as? Dictionary<String, Int>,
           let time = args["time"] {
            let date = Date(timeIntervalSince1970: TimeInterval(time/1000))
            let defaults = UserDefaults(suiteName: "group.com.intosharp.hantongbox")
            defaults?.set(date, forKey: "lastTime")
            defaults?.synchronize()
        }
        
        if #available(macOS 11, *) { self.reloadAllTimelines() }
        
        result(true)
    }
*/
    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }
/*
    @available(macOS 11, *)
    func reloadAllTimelines() {
        #if arch(arm64) || arch(i386) || arch(x86_64) || os(macOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
*/
}
