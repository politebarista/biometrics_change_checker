import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biometrics_change_checker/src/biometrics_change_checker_method_channel.dart';

void main() {
  MethodChannelBiometricsChangeChecker platform =
      MethodChannelBiometricsChangeChecker();
  const MethodChannel channel = MethodChannel('biometrics_change_checker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.didBiometricsChanged(), '42');
  });
}
