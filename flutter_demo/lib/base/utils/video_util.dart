import 'package:flutter/material.dart';

/// 作者：李佳奇
/// 日期：2021/5/6
/// 备注：视频处理类

class VideoUtil {

  static const _ossProcess = '?x-oss-process';

  static const _videoOrder = '=video/snapshot';

  static bool checkUrlLegal(String url) {
    return url.contains(_ossProcess);
  }


  /// 获取视频某时间点的图片
  /// [position] 截取位置，单位ms
  /// [clipWidth] [clipHeight] 截取宽高、单位像素
  /// [m] 截取模式 ， 不指定则为默认模式，根据时间精确截图。如果指定为fast，则截取该时间点之前的最近的一个关键帧。
  /// [format] 输出图片格式，支持 jpg,png
  /// [ar] 指定是否根据视频信息自动旋转图片。如果指定为auto，则在截图生成之后根据视频信息进行自动旋转。
  ///
  static String getVideoSnapShot(String videoUrl,{int position = 0,
    int clipWidth = 0,int clipHeight = 0,String m = 'fast',String format = 'jpg',String? ar}) {
    if(checkUrlLegal(videoUrl)) return videoUrl;
    String targetUrl;
    if(ar == null) {
      targetUrl = videoUrl  + _ossProcess + _videoOrder
          + ',t_$position,f_$format,w_$clipWidth,h_$clipHeight,m_$m';
    } else {
      targetUrl = videoUrl  + _ossProcess + _videoOrder
          + ',t_$position,f_$format,w_$clipWidth,h_$clipHeight,m_$m,$ar';
    }
    debugPrint(targetUrl);
    return  targetUrl;
  }



}

///将视频播放时间格式化用于展示
String formatVideoDuration(int position) {
  final ms = position;

  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  final minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
      ? '00'
      : '0$hours';

  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
      ? '00'
      : '0$minutes';

  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
      ? '00'
      : '0$seconds';

  final formattedTime =
      '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

  return formattedTime;
}



















