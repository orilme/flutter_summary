import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/base/utils/screen_util/flutter_screenutil.dart';
import 'package:flutter_demo/base/extension/string_extension.dart';

/// Toast基类

abstract class ToastBaseWidget extends StatelessWidget {
  const ToastBaseWidget({
    Key? key,
    required this.msg,
    required this.radius,
    required this.backgroundColor,
    required this.fontSize,
    required this.textColor,
  }) : super(key: key);

  static const Color kBackgroundColor = Color(0xE6666666);
  static final double kRadius = 8.w;
  static final double kFontSize = 13.sp;
  static final double kHorizontalMargin = 60.w;

  final String msg;
  final double? radius;
  final Color? backgroundColor;
  final double? fontSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final double r = radius ?? kRadius;
    final Color bgColor = backgroundColor ?? kBackgroundColor;
    final double fs = fontSize ?? kFontSize;
    final Color color = textColor ?? Colors.white;
    final double fontHeight = Platform.isIOS ? 1.5 : 1.3;
    return buildToastWidget(
      radius: r,
      backgroundColor: bgColor,
      fontSize: fs,
      textColor: color,
      fontHeight: fontHeight,
    );
  }

  /// 构建Toast样式
  Widget buildToastWidget({
    required double radius,
    required Color backgroundColor,
    required double fontSize,
    required Color textColor,
    required double fontHeight,
  });
}

///
/// 普通Toast样式
///
/// Created by Jack Zhang on 2021/11/22 .
///
class ToastNormalWidget extends ToastBaseWidget {
  const ToastNormalWidget({
    Key? key,
    required String msg,
    double? radius,
    Color? backgroundColor,
    double? fontSize,
    Color? textColor,
  }) : super(
          key: key,
          msg: msg,
          radius: radius,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          textColor: textColor,
        );

  @override
  Widget buildToastWidget({
    required double radius,
    required Color backgroundColor,
    required double fontSize,
    required Color textColor,
    required double fontHeight,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ToastBaseWidget.kHorizontalMargin),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius), color: backgroundColor),
      child: Text(
        msg.showContent,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          leadingDistribution: TextLeadingDistribution.even,
          height: fontHeight,
        ),
      ),
    );
  }
}

/// 成功Toast样式
class ToastSuccessWidget extends ToastBaseWidget {
  const ToastSuccessWidget({
    Key? key,
    required String msg,
    double? radius,
    Color? backgroundColor,
    double? fontSize,
    Color? textColor,
  }) : super(
          key: key,
          msg: msg,
          radius: radius,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          textColor: textColor,
        );

  @override
  Widget buildToastWidget({
    required double radius,
    required Color backgroundColor,
    required double fontSize,
    required Color textColor,
    required double fontHeight,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ToastBaseWidget.kHorizontalMargin),
      child: Center(
        child: Container(
          constraints: BoxConstraints(minWidth: 100.w, minHeight: 82.w),
          padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w, bottom: 16.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius), color: backgroundColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(3.w),
                child: Icon(
                  Icons.add, // 应该替换为✅图标
                  size: 26.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                msg.showContent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  leadingDistribution: TextLeadingDistribution.even,
                  height: fontHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
