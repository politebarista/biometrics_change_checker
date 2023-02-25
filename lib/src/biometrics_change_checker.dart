import 'biometrics_change_checker_platform_interface.dart';
import 'utils/biometrics_change_status.dart';

class BiometricsChangeChecker {
  Future<BiometricsChangeStatus> didBiometricChanged() {
    return BiometricsChangeCheckerPlatform.instance.didBiometricsChanged();
  }
}
