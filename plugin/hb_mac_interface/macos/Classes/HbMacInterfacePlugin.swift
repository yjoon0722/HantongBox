import Cocoa
import FlutterMacOS

public class HbMacInterfacePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hb_mac_interface", binaryMessenger: registrar.messenger)
    let instance = HbMacInterfacePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "setLastTime":

        debugPrint("native-\(#function)")
        //debugPrint(call.arguments)

        if let args = call.arguments as? Dictionary<String, Int>, let time = args["time"] {
            debugPrint("-TIME: \(time)")
            
            let date = Date(timeIntervalSince1970: TimeInterval(time/1000))
            let defaults = UserDefaults(suiteName: "group.com.intosharp.hantongbox")
            defaults?.set(date, forKey: "lastTime")
            defaults?.synchronize()
        }
        result(true)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
