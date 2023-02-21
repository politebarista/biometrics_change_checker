#import "BiometricsChangeCheckerPlugin.h"
#if __has_include(<biometrics_change_checker/biometrics_change_checker-Swift.h>)
#import <biometrics_change_checker/biometrics_change_checker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "biometrics_change_checker-Swift.h"
#endif

@implementation BiometricsChangeCheckerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBiometricsChangeCheckerPlugin registerWithRegistrar:registrar];
}
@end
