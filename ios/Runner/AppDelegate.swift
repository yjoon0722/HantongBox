import UIKit
import Flutter
import WidgetKit
import Firebase

//@available(iOS 9.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var shortcutItemToProcess: UIApplicationShortcutItem?
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        debugPrint("native-\(#function)")
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
                shortcutItemToProcess = shortcutItem
            }
        }
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let lastTimeChannel = FlutterMethodChannel(name: "hantongbox.save/lastTime", binaryMessenger: controller.binaryMessenger)
        lastTimeChannel.setMethodCallHandler { (call, result) in
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
            
            if #available(iOS 14, *) { self.reloadAllTimelines() }
            
            result(true)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    @available(iOS 9.0, *)
    override func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        debugPrint("native-\(#function)")
        if #available(iOS 14, *) { self.reloadAllTimelines() }
        if let shortcutItem = shortcutItemToProcess {
            let controller = window.rootViewController as? FlutterViewController
            let channel = FlutterMethodChannel(name: "plugins.flutter.io/quick_actions", binaryMessenger: controller! as! FlutterBinaryMessenger)
            channel.invokeMethod("launch", arguments: shortcutItem.type)
            shortcutItemToProcess = nil
        }
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("native-\(#function)")
        if #available(iOS 14, *) { self.reloadAllTimelines() }
    }
    
    @available(iOS 14, *)
    func reloadAllTimelines() {
        #if arch(arm64) || arch(i386) || arch(x86_64)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
}
