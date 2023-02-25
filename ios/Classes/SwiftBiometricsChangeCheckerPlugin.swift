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
        switch (call.method) {
        case "didBiometricsChanged":
            didBiometricsChanged(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func didBiometricsChanged(result: @escaping FlutterResult) {
        let context = LAContext()
        var authError : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) == false {
            result(FlutterError(code: "unknown", message: nil, details: nil))
            return
        }
        
        var currentToken: String?
        if let biometricsData = context.evaluatedPolicyDomainState {
            let base64Data = biometricsData.base64EncodedData()
            let token = String(data: base64Data, encoding: .utf8)
            currentToken = token
        } else {
            result(FlutterError(code: "unknown", message: nil, details: nil))
            return
        }
        
        var savedToken = getBiometricsTokenFromKeychain()
        if savedToken == nil {
            saveBiometricsTokenInKeychain(token: currentToken!)
            // TODO: it is necessary to check the expected behavior in this case
            result(false)
            return
        }
        
        let biometricsHasBeenChanged = savedToken! != currentToken!
        
        if biometricsHasBeenChanged { replaceBiometricsTokenInKeychain(token: currentToken!) }
        
        result(biometricsHasBeenChanged)
        return
    }
    
    private func getBiometricsTokenFromKeychain() -> String? {
        let getQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let gettingFromKeychainStatus = SecItemCopyMatching(
            getQuery as CFDictionary,
            &item
        )
        
        return item == nil ? nil : String(decoding: (item! as? Data)!, as: UTF8.self)
    }
    
    private func saveBiometricsTokenInKeychain(token: String) {
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecValueData as String: token.data(using: .utf8)
        ]
        
        let addingToKeychainStatus = SecItemAdd(
            addQuery as CFDictionary,
            nil
        )
        
        guard addingToKeychainStatus != errSecDuplicateItem else {
            // TODO: add throwing result(FlutterError)
            return
        }
        
        guard addingToKeychainStatus == errSecSuccess else {
            // TODO: add throwing result(FlutterError)
            return
        }
    }
    
    private func replaceBiometricsTokenInKeychain(token: String) {
        let receiveDataQuery: [String: Any] = [
            kSecClass as String: kSecClassKey
        ]
        
        let changeDataQuery: [String: Any] = [
            kSecValueData as String: token.data(using: .utf8)
        ]
        
        let status = SecItemUpdate(receiveDataQuery as CFDictionary, changeDataQuery as CFDictionary)
        
        guard status != errSecItemNotFound else {
            // TODO: add throwing result(FlutterError)
            return
        }
        
        guard status == errSecSuccess else {
            // TODO: add throwing result(FlutterError)
            return
        }
    }
}
