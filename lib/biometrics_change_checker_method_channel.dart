import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'biometrics_change_checker_platform_interface.dart';

/// An implementation of [BiometricsChangeCheckerPlatform] that uses method channels.
class MethodChannelBiometricsChangeChecker extends BiometricsChangeCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('biometrics_change_checker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
