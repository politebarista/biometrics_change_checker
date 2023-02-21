import 'package:biometrics_change_checker/utils/biometrics_change_status.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'biometrics_change_checker_method_channel.dart';

abstract class BiometricsChangeCheckerPlatform extends PlatformInterface {
  /// Constructs a BiometricsChangeCheckerPlatform.
  BiometricsChangeCheckerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BiometricsChangeCheckerPlatform _instance =
      MethodChannelBiometricsChangeChecker();

  /// The default instance of [BiometricsChangeCheckerPlatform] to use.
  ///
  /// Defaults to [MethodChannelBiometricsChangeChecker].
  static BiometricsChangeCheckerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BiometricsChangeCheckerPlatform] when
  /// they register themselves.
  static set instance(BiometricsChangeCheckerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<BiometricsChangeStatus> didBiometricsChanged() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
