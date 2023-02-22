import 'dart:developer';

import 'package:biometrics_change_checker/utils/biometrics_change_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'biometrics_change_checker_platform_interface.dart';

/// An implementation of [BiometricsChangeCheckerPlatform] that uses method channels.
class MethodChannelBiometricsChangeChecker
    extends BiometricsChangeCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('biometrics_change_checker');

  @override
  Future<BiometricsChangeStatus> didBiometricsChanged() async {
    try {
      // final result =
      //     await methodChannel.invokeMethod<bool>('didBiometricsChanged');
      final result =
          await methodChannel.invokeMethod<String>('didBiometricsChanged');
      return result == 0
          ? BiometricsChangeStatus.changed
          : BiometricsChangeStatus.notChanged;
    } on PlatformException catch (e) {
      log(e.message.toString());
      return BiometricsChangeStatus.invalid;
    }
  }
}