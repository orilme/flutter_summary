import 'dart:io';

import 'package:flutter/services.dart';
import 'package:orientation/orientation.dart';

import 'log_util.dart';

class OrientationUtil {
  static bool isPortrait = true;

  static void screenSwitch() {
    if (isPortrait) {
      landscape();
    } else {
      portrait();
    }
  }

  static void landscape() {
    LogUtil.v("横屏");
    isPortrait = false;
    OrientationPlugin.forceOrientation(DeviceOrientation.landscapeRight);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    if (Platform.isIOS) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    }
  }

  static void portrait() {
    LogUtil.v("竖屏");
    isPortrait = true;
    OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
    if (Platform.isIOS) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  static void restore() {
    SystemChrome.restoreSystemUIOverlays();
  }
}
