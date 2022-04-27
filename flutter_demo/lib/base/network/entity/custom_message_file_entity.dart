import 'dart:io';

///
/// 自定义类型消息文件实体类
///
/// Created by Jack Zhang on 12/28/20 .
///

enum CustomMessageFileStatus { success, failed }

class CustomMessageFileEntity {
  ///网络地址
  String? fileUrl;

  //文件名字
  String? fileName;

  //文件大小
  int? fileSize;

  //视频缩略图
  String? videoThumbnailUrl;

  //本地地址
  String? localPath;

  /// uuid 上传时候的唯一id
  String? uuid;

  /// 宽
  int? width;

  ///高
  int? height;

  /// 视频时长
  int? duration;

  /// 此文件状态
  CustomMessageFileStatus fileStatus = CustomMessageFileStatus.failed;

  String? filePath;//原始路径

  @override
  String toString() {
    return 'CustomMessageFileEntity{fileUrl: $fileUrl, fileName: $fileName, fileSize: $fileSize, videoThumbnailUrl: $videoThumbnailUrl, localPath: $localPath, uuid: $uuid, width: $width, height: $height, duration: $duration, fileStatus: $fileStatus}';
  }
}
