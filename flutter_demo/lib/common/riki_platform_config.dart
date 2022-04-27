import 'dart:io';
import 'config.dart';

abstract class RikiPlatformConfig {
  final String android;
  final String ios;

  RikiPlatformConfig(this.android, this.ios);

  String get value => Platform.isAndroid
      ? android
      : Platform.isIOS
          ? ios
          : '';
}

abstract class RikiEnvConfig {
  final dynamic dev;
  final dynamic stage;
  final dynamic release;

  RikiEnvConfig(this.dev, this.stage, this.release);

  dynamic get value => AppConfig.instance.isDevelopEnv
      ? dev
      : AppConfig.instance.isStageEnv
          ? stage
          : release;
}
