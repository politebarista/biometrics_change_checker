import Flutter
import UIKit
import LocalAuthentication
import Security

public class SwiftBiometricsChangeCheckerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "biometrics_change_checker", binaryMessenger: registrar.messenger())
    let instance = SwiftBiometricsChangeCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let context = LAContext()
      var authError : NSError?
      
      print("updated code")
      // let addQuery: [String: Any] = [
      //   kSecClass as String: kSecClassKey,
      //   kSecValueData as String: "token-example-testing".data(using: .utf8)
      // ]
      
      // let addingToKeychainStatus = SecItemAdd(
      //   addQuery as CFDictionary,
      //   nil
      // )
      
      // guard addingToKeychainStatus != errSecDuplicateItem else {
      //     print("duplicate")
      //     return
      // }
      
      // guard addingToKeychainStatus == errSecSuccess else {
      //     print("unknown error \(addingToKeychainStatus)")
      //     return
      // }
      
      // print("saved successfully")
      
      guard let data = getToken() else {
        print("failed to read data")
        return
      }
      print("data \(data)")
      let token = String(decoding: data, as: UTF8.self)
      print("token \(token)")

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

    public func getToken() -> Data? {
       let getQuery: [String: Any] = [
         kSecClass as String: kSecClassKey,
         kSecReturnData as String: kCFBooleanTrue,
         kSecMatchLimit as String: kSecMatchLimitOne
       ]
       print("query compilation completed")

       var item: AnyObject?
       let gettingFromKeychainStatus = SecItemCopyMatching(
         getQuery as CFDictionary,
         &item
       )
        print("getting item is completed\nitem - \(item)")

        return item as? Data

//
//        print(gettingFromKeychainStatus)
//        guard item as? Data != nil else {
//          print("item is nil")
//          return
//        }
//
//        let data = item! as? Data
//        let password = String(decoding: data, as: UTF8.self)
//        print("item is \(password)")
    }
}
