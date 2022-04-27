import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'toast.dart';

class ToastUtil {
  static int? _lastToastTime;
  static String? _lastToastText;

  /// 操作注意事项提醒Toast —— 普通Toast
  static void show(
    String? msg, {
    int duration = 2000,
    double? radius,
    Color? backgroundColor,
    double? fontSize,
    Color? textColor,
  }) {
    if (msg == null || msg.isEmpty || msg.trim() == '') {
      return;
    }

    // 如果是重复文案，且旧的toast并未消失，那么，不再显示新的Toast
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (_lastToastText == msg && _lastToastTime != null && now - _lastToastTime! < duration) {
      return;
    }

    _lastToastText = msg;
    _lastToastTime = now;

    final Widget widget = ToastNormalWidget(
      msg: msg,
      radius: radius,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      textColor: textColor,
    );

    showToastWidget(
      widget,
      duration: Duration(milliseconds: duration),
      dismissOtherToast: true,
    );
  }

  /// 操作结果反馈Toast —— 成功Toast
  static void showSuccess(
    String? msg, {
    int duration = 2000,
    double? radius,
    Color? backgroundColor,
    double? fontSize,
    Color? textColor,
  }) {
    if (msg == null || msg.isEmpty || msg.trim() == '') {
      return;
    }

    // 如果是重复文案，且旧的toast并未消失，那么，不再显示新的Toast
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (_lastToastText == msg && _lastToastTime != null && now - _lastToastTime! < duration) {
      return;
    }

    _lastToastText = msg;
    _lastToastTime = now;

    final Widget widget = ToastSuccessWidget(
      msg: msg,
      radius: radius,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      textColor: textColor,
    );

    showToastWidget(
      widget,
      duration: Duration(milliseconds: duration),
      dismissOtherToast: true,
    );
  }

  static void cancelToast() {
    dismissAllToast();
  }

  /// 弹出成功Toast
  @Deprecated('请使用ToastUtil.show')
  static void showPositiveToast(
    String msg, {
    int duration = 2000,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
  }) {
    show(msg, duration: duration, backgroundColor: backgroundColor, textColor: textColor, fontSize: fontSize);
  }

  /// 弹出失败/错误Toast
  @Deprecated('请使用ToastUtil.show')
  static void showNegativeToast(
    String? msg, {
    int duration = 2000,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
  }) {
    show(msg, duration: duration, backgroundColor: backgroundColor, textColor: textColor, fontSize: fontSize);
  }
}
