//
//  DirectDialerPlugin.swift
//  direct_dialer
//
//  Created by Reuben Turner on 3/12/21.
//

import Flutter
import UIKit

public class SwiftDirectDialerPlugin: NSObject, FlutterPlugin {
    var result: FlutterResult?
    var number: String?
    var window: UIWindow?

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true;
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "direct_dialer", binaryMessenger: registrar.messenger())
        let instance = SwiftDirectDialerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result;
        switch (call.method) {
        case "dial":
            if let args = call.arguments as? Dictionary<String, Any> {
                self.number = args["number"] as? String;
                dial(phoneNumber: number!);
            }
            break;
        default:
            break;
        }
    }

    private func dial(phoneNumber:String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
}
