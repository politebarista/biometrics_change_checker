import Flutter
import UIKit
import LocalAuthentication

public class SwiftBiometricsChangeCheckerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "biometrics_change_checker", binaryMessenger: registrar.messenger())
    let instance = SwiftBiometricsChangeCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let context = LAContext()
      var authError : NSError?

      if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) == false {
        result(FlutterError(code: "unknown", message: nil, details: nil))
        return
      }

      if let biometricsData = context.evaluatedPolicyDomainState {
            let base64Data = biometricsData.base64EncodedData()
            let token = String(data: base64Data, encoding: .utf8)
            result(token)
      } else {
        result(FlutterError(code: "unknown", message: nil, details: nil))
      }
  }
}
