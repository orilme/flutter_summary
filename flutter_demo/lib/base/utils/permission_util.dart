import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// 4.0->5.0兼容
enum PermissionGroup {
  calendar,
  camera,
  contacts,
  location,
  locationAlways,
  locationWhenInUse,
  mediaLibrary,
  microphone,
  phone,
  photos,
  photosAddOnly,
  reminders,
  sensors,
  sms,
  speech,
  storage,
  ignoreBatteryOptimizations,
  notification,
  accessMediaLocation,
  activityRecognition,
  unknown,
  bluetooth,
  manageExternalStorage,
  systemAlertWindow,
  requestInstallPackages,
  appTrackingTransparency,
  criticalAlerts,
  accessNotificationPolicy,
}

class PermissionUtil {
  static const Map<PermissionGroup, String> _PERMISSION_TIPS = {
    PermissionGroup.calendar: '请到设置中开启日历权限',
    PermissionGroup.camera: '请到设置中开启摄像头权限',
    PermissionGroup.contacts: '请到设置中开启通讯录权限',
    PermissionGroup.location: '请到设置中开启定位权限',
    PermissionGroup.locationAlways: '请到设置中开启定位权限',
    PermissionGroup.locationWhenInUse: '请到设置中开启定位权限',
    PermissionGroup.mediaLibrary: '请到设置中开启媒体资料库权限',
    PermissionGroup.microphone: '请到设置中开启麦克风权限',
    PermissionGroup.phone: '请到设置中开启电话权限',
    PermissionGroup.photos: '请到设置中开启相册权限',
    PermissionGroup.photosAddOnly: '请到设置中开启相册权限',
    PermissionGroup.reminders: '请到设置中开启提醒事项权限',
    PermissionGroup.sensors: '请到设置中开启传感器权限',
    PermissionGroup.sms: '请到设置中开启短信权限',
    PermissionGroup.speech: '请到设置中开启Siri权限',
    PermissionGroup.storage: '请到设置中开启存储权限',
    PermissionGroup.ignoreBatteryOptimizations: '请到设置中开启忽略节电',
    PermissionGroup.notification: '请到设置中开启通知权限',
    PermissionGroup.accessMediaLocation: '请到设置中开启私有存储权限',
    PermissionGroup.activityRecognition: '请到设置中开启活动识别',
    PermissionGroup.unknown: '请到设置中开启所需权限',
    PermissionGroup.bluetooth: '请到设置中开启所需权限',
    PermissionGroup.manageExternalStorage: '请到设置中开启所需权限',
    PermissionGroup.systemAlertWindow: '请到设置中开启所需权限',
    PermissionGroup.requestInstallPackages: '请到设置中开启所需权限',
    PermissionGroup.appTrackingTransparency: '请到设置中开启所需权限',
    PermissionGroup.criticalAlerts: '请到设置中开启所需权限',
    PermissionGroup.accessNotificationPolicy: '请到设置中开启所需权限',
  };

  static const List<PermissionGroup> _ANDROID_GROUP = [
    PermissionGroup.calendar,
    PermissionGroup.camera,
    PermissionGroup.contacts,
    PermissionGroup.location,
    PermissionGroup.locationAlways,
    PermissionGroup.locationWhenInUse,
    PermissionGroup.microphone,
    PermissionGroup.phone,
    PermissionGroup.sensors,
    PermissionGroup.sms,
    PermissionGroup.speech,
    PermissionGroup.storage,
    PermissionGroup.ignoreBatteryOptimizations,
    PermissionGroup.notification,
    PermissionGroup.accessMediaLocation,
    PermissionGroup.activityRecognition,
    PermissionGroup.unknown,
    PermissionGroup.manageExternalStorage,
    PermissionGroup.systemAlertWindow,
    PermissionGroup.requestInstallPackages,
    PermissionGroup.accessNotificationPolicy,
  ];

  static const List<PermissionGroup> _IOS_GROUP = [
    PermissionGroup.calendar,
    PermissionGroup.camera,
    PermissionGroup.contacts,
    PermissionGroup.location,
    PermissionGroup.locationAlways,
    PermissionGroup.locationWhenInUse,
    PermissionGroup.mediaLibrary,
    PermissionGroup.microphone,
    PermissionGroup.photos,
    PermissionGroup.photosAddOnly,
    PermissionGroup.reminders,
    PermissionGroup.sensors,
    PermissionGroup.speech,
    PermissionGroup.notification,
    PermissionGroup.unknown,
    PermissionGroup.bluetooth,
    PermissionGroup.appTrackingTransparency,
    PermissionGroup.criticalAlerts,
  ];

  static List<PermissionGroup> devicePermissions(List<PermissionGroup> permissions) {
    List<PermissionGroup> temp = [];
    if (Platform.isAndroid) {
      permissions.forEach((value) {
        if (_ANDROID_GROUP.indexOf(value) != -1) {
          temp.add(value);
        }
      });
    } else if (Platform.isIOS) {
      permissions.forEach((value) {
        if (_IOS_GROUP.indexOf(value) != -1) {
          temp.add(value);
        }
      });
    }
    return temp;
  }

  /// 检测是否授予权限组的权限
  /// [permissions] 权限组
  /// [toast] 是否支持吐丝，默认吐丝
  static Future<bool> checkGroup(List<PermissionGroup> permissions, {bool toast = true}) async {
    bool granted = true;
    permissions = devicePermissions(permissions);
    for (PermissionGroup permission in permissions) {
      PermissionStatus status = await Permission.byValue(permission.index).status;
      if (status != PermissionStatus.granted) {
        granted = false;
        if (toast) {
          AlertDialog(
            title: Text('提示'),
            content: Text('${_getPermissionTips(permission)}'),
            actions: <Widget>[
              FlatButton(
                child: Text('我知道了'),
                onPressed: () {},
              ),
            ],
          );
          // ToastUtil.show(_getPermissionTips(permission));
        }
        break;
      }
    }
    return Future.value(granted);
  }

  /// 检测是否授予权限
  /// [permission] 所需的权限
  static Future<bool> check(PermissionGroup permission, {bool toast = true}) async {
    return checkGroup([permission], toast: toast);
  }

  /// 注册权限组
  /// [permissions] 所需注册的权限组
  /// [isPermanentlyDenied] android 如果是询问是否toast,不获取
  static Future<bool> requestGroup(List<PermissionGroup> permissions, {bool isPermanentlyDenied = false}) async {
    permissions = devicePermissions(permissions);

    List<Permission> perList = permissions.map((value) {
      return Permission.byValue(value.index);
    }).toList();

    List<Permission> temp = [];
    bool granted = true;
    for (Permission permission in perList) {
      PermissionStatus status = await permission.status;
      if (status.isPermanentlyDenied && isPermanentlyDenied) {
        AlertDialog(
          title: Text('提示'),
          content: Text('${_getPermissionTips(PermissionGroup.values[Permission.values.indexOf(permission)])}'),
          actions: <Widget>[
            FlatButton(
              child: Text('我知道了'),
              onPressed: () {},
            ),
          ],
        );
        // ToastUtil.show(_getPermissionTips(PermissionGroup.values[Permission.values.indexOf(permission)]));
        granted = false;
      } else if (!status.isGranted) {
        temp.add(permission);
      }
    }
    perList = temp;

    if (perList.isEmpty) {
      return Future.value(granted);
    }

    Map<Permission, PermissionStatus> group = await perList.request();
    for (Permission permission in group.keys) {
      PermissionStatus? status = group[permission];
      if (Platform.isIOS) {
        if (status != PermissionStatus.granted) {
          if (status == PermissionStatus.limited) {
            granted = true;
          } else {
            granted = false;
            AlertDialog(
              title: Text('提示'),
              content: Text('${_getPermissionTips(PermissionGroup.values[Permission.values.indexOf(permission)])}'),
              actions: <Widget>[
                FlatButton(
                  child: Text('我知道了'),
                  onPressed: () {},
                ),
              ],
            );
            // ToastUtil.show(_getPermissionTips(PermissionGroup.values[Permission.values.indexOf(permission)]));
          }
        }
      } else {
        if (status != PermissionStatus.granted) {
          granted = false;
          AlertDialog(
            title: Text('提示'),
            content: Text('${_getPermissionTips(PermissionGroup.values[Permission.values.indexOf(permission)])}'),
            actions: <Widget>[
              FlatButton(
                child: Text('我知道了'),
                onPressed: () {},
              ),
            ],
          );
          // ToastUtil.show(_getPermissionTips(PermissionGroup.values[Permission.values.indexOf(permission)]));
          break;
        }
      }
    }
    return Future.value(granted);
  }

  static Future<bool> request(PermissionGroup permission) async {
    return requestGroup([permission]);
  }

  static String? _getPermissionTips(PermissionGroup permission) {
    return _PERMISSION_TIPS.containsKey(permission) ? _PERMISSION_TIPS[permission] : '请到设置中开启所需权限';
  }

  static void openPermissionSettings() {
    openAppSettings();
  }
}
