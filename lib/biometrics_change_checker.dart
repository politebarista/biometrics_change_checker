import 'package:biometrics_change_checker/utils/biometrics_change_status.dart';

import 'biometrics_change_checker_platform_interface.dart';

class BiometricsChangeChecker {
  Future<BiometricsChangeStatus> didBiometricChanged() {
    return BiometricsChangeCheckerPlatform.instance.didBiometricsChanged();
  }
}
