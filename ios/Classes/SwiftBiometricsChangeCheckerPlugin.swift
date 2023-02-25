import Flutter
import UIKit
import LocalAuthentication
import Security

// TODO: format the code
// TODO: delete comments
public class SwiftBiometricsChangeCheckerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "biometrics_change_checker", binaryMessenger: registrar.messenger())
    let instance = SwiftBiometricsChangeCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  // TODO: need to handle different methods, not only "didBiometricsChanged"
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("start")
     let context = LAContext()
      var authError : NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) == false {
        result(FlutterError(code: "unknown", message: nil, details: nil))
        return
      }
      print("after evaluating policy")

    var currentToken: String?
      if let biometricsData = context.evaluatedPolicyDomainState {
            let base64Data = biometricsData.base64EncodedData()
            let token = String(data: base64Data, encoding: .utf8)
            currentToken = token
      } else {
        print("failing evaluating policy")
        result(FlutterError(code: "unknown", message: nil, details: nil))
        return
      }
      print("after evaluating policy domain state \(currentToken)")

      var savedToken = getBiometricsTokenFromKeychain()
      if savedToken == nil {
        print("saved token is nil so saving this one")
        saveBiometricsTokenInKeychain(token: currentToken!)
        // TODO: it is necessary to check the expected behavior in this case
        result(false)
        return
      }

      print("saved token - \(savedToken)")
      print("current token - \(currentToken)")
      print("checking tokens equality - \(savedToken! == currentToken!)")
      
      let biometricsHasBeenChanged = savedToken! != currentToken!
      
      if biometricsHasBeenChanged { replaceBiometricsToken(token: currentToken!) }
      
      result(biometricsHasBeenChanged)
      return
  }

    // TODO: I think need to make it private
    public func getBiometricsTokenFromKeychain() -> String? {
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

        return item == nil ? nil : String(decoding: (item! as? Data)!, as: UTF8.self)
    }

    // TODO: I think need to make it private
    public func replaceBiometricsToken(token: String) {
      print("replacement is needed")
        let receiveDataQuery: [String: Any] = [
            kSecClass as String: kSecClassKey
        ]
        
        let changeDataQuery: [String: Any] = [
            kSecValueData as String: token.data(using: .utf8)
        ]
        
        let status = SecItemUpdate(receiveDataQuery as CFDictionary, changeDataQuery as CFDictionary)
        print(status)
        
        guard status != errSecItemNotFound else {
            print("there is no such item")
            return
        }
        
        guard status == errSecSuccess else {
            print("unknown error \(status)")
            return
        }

        print("changed successfully")
    }
    
    // TODO: I think need to make it private
    public func saveBiometricsTokenInKeychain(token: String) {
      let addQuery: [String: Any] = [
        kSecClass as String: kSecClassKey,
        kSecValueData as String: token.data(using: .utf8)
      ]
      
      let addingToKeychainStatus = SecItemAdd(
        addQuery as CFDictionary,
        nil
      )
      
      guard addingToKeychainStatus != errSecDuplicateItem else {
          print("duplicate")
          return
      }
      
      guard addingToKeychainStatus == errSecSuccess else {
          print("unknown error \(addingToKeychainStatus)")
          return
      }
      
      print("saved successfully")
    }
}
