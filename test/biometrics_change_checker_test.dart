import 'package:biometrics_change_checker/src/utils/biometrics_change_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biometrics_change_checker/src/biometrics_change_checker.dart';
import 'package:biometrics_change_checker/src/biometrics_change_checker_platform_interface.dart';
import 'package:biometrics_change_checker/src/biometrics_change_checker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBiometricsChangeCheckerPlatform
    with MockPlatformInterfaceMixin
    implements BiometricsChangeCheckerPlatform {
  @override
  Future<BiometricsChangeStatus> didBiometricsChanged() =>
      Future.value(BiometricsChangeStatus.changed);
}

void main() {
  final BiometricsChangeCheckerPlatform initialPlatform =
      BiometricsChangeCheckerPlatform.instance;

  test('$MethodChannelBiometricsChangeChecker is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelBiometricsChangeChecker>());
  });

  test('getPlatformVersion', () async {
    BiometricsChangeChecker biometricsChangeCheckerPlugin =
        BiometricsChangeChecker();
    MockBiometricsChangeCheckerPlatform fakePlatform =
        MockBiometricsChangeCheckerPlatform();
    BiometricsChangeCheckerPlatform.instance = fakePlatform;

    expect(await biometricsChangeCheckerPlugin.didBiometricChanged(), '42');
  });
}
