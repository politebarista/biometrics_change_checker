
import 'biometrics_change_checker_platform_interface.dart';

class BiometricsChangeChecker {
  Future<String?> getPlatformVersion() {
    return BiometricsChangeCheckerPlatform.instance.getPlatformVersion();
  }
}
