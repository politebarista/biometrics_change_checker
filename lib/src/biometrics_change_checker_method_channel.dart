import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'biometrics_change_checker_platform_interface.dart';
import 'utils/biometrics_change_status.dart';

/// An implementation of [BiometricsChangeCheckerPlatform] that uses method channels.
class MethodChannelBiometricsChangeChecker
    extends BiometricsChangeCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('biometrics_change_checker');

  @override
  Future<BiometricsChangeStatus> didBiometricsChanged() async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final result =
            await methodChannel.invokeMethod<bool>('didBiometricsChanged');
        return result == true
            ? BiometricsChangeStatus.changed
            : BiometricsChangeStatus.notChanged;
      } on PlatformException catch (e) {
        log(e.message.toString());
        return BiometricsChangeStatus.invalid;
      }
    } else {
      throw UnimplementedError();
    }
  }
}
