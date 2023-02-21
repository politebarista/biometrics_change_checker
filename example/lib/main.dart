import 'dart:async';

import 'package:biometrics_change_checker/utils/biometrics_change_status.dart';
import 'package:flutter/material.dart';
import 'package:biometrics_change_checker/biometrics_change_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BiometricsChangeStatus? _platformVersion;
  final _biometricsChangeCheckerPlugin = BiometricsChangeChecker();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    BiometricsChangeStatus biometricsChangeStatus =
        await _biometricsChangeCheckerPlugin.didBiometricChanged();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = biometricsChangeStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Status: $_platformVersion\n'),
        ),
      ),
    );
  }
}
