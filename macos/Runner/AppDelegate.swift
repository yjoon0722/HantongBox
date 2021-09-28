import Cocoa
import FlutterMacOS
import Firebase
import WidgetKit

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
/*
    override func applicationDidFinishLaunching(_ notification: Notification) {
        debugPrint("native-\(#function)")
//        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
//        debugPrint(controller)
//        debugPrint("controller OK")
//        let lastTimeChannel = FlutterMethodChannel(name: "hantongbox.save/lastTime", binaryMessenger: controller.engine.binaryMessenger)
//        debugPrint(lastTimeChannel)
//        debugPrint("lasTimeChannel OK")
//        lastTimeChannel.setMethodCallHandler { (call, result) in
//            debugPrint("setMethodCallHandler init")
//            debugPrint("native- setMethodCallHandler")
//
//            guard call.method == "setLastTime" else {
//                result(FlutterMethodNotImplemented)
//                return
//            }
//
//            if let args = call.arguments as? Dictionary<String, Int>,
//               let time = args["time"] {
//                let date = Date(timeIntervalSince1970: TimeInterval(time/1000))
//                let defaults = UserDefaults(suiteName: "group.com.intosharp.hantongbox")
//                defaults?.set(date, forKey: "lastTime")
//                defaults?.synchronize()
//
//                debugPrint("native- synchronize")
//            }
//
//            if #available(macOS 11, *) { self.reloadAllTimelines() }
//
//            result(true)
//        }
//        return super.applicationDidFinishLaunching(notification)
    }
*/
    override func applicationDidHide(_ notification: Notification) {
        debugPrint("native-\(#function)")
        if #available(macOS 11, *) { self.reloadAllTimelines() }
    }

    override func applicationDidUnhide(_ notification: Notification) {
        debugPrint("native-\(#function)")
        if #available(macOS 11, *) { self.reloadAllTimelines() }
    }

    override func applicationDidBecomeActive(_ notification: Notification) {
        debugPrint("native-\(#function)")
        if #available(macOS 11, *) { self.reloadAllTimelines() }
    }

    override func applicationDidResignActive(_ notification: Notification) {
        debugPrint("native-\(#function)")
        if #available(macOS 11, *) { self.reloadAllTimelines() }
    }

    @available(macOS 11, *)
    func reloadAllTimelines() {
        #if arch(arm64) || arch(i386) || arch(x86_64) || os(macOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
    
}
