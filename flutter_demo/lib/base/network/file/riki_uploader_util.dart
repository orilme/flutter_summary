import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../api/oss_api.dart';
import '../entity/custom_message_file_entity.dart';
import '../entity/upload_file_oss_entity.dart';

import 'riki_file_util.dart';
import 'package:flutter_demo/base/utils/text_util.dart';
import 'package:flutter_demo/base/utils/log_util.dart';
import 'package:flutter_demo/base/utils/dio_upload_util.dart';
import 'package:flutter_demo/base/network/file/image_compress_utils.dart';
import 'package:flutter_demo/base/utils/toast/toast_util.dart';

typedef OnConfiguringOss = Future<UploadFileOssEntity> Function();

enum RikiFileUploadType {
  NORMAL, //默认普通文件
  IMAGE, //图片
  VIDEO, //视频
}

class RikiUploaderUtil {
  static const String _TAG = 'RikiUploaderUtil';

  static void _log(Object msg) {
    LogUtil.v(msg, tag: _TAG);
  }

  ///获取上传oss的文件名称
  static String getUpLoadOssFileName(String fileName) {
    late String upLoadFileName;
    if (fileName.contains('.')) {
      upLoadFileName = fileName.split('.').last;
    }
    return DateTime.now().millisecondsSinceEpoch.toString() + ImageCompressUtils.randomBit(10).toString() + "." + upLoadFileName;
  }

  /// 压缩视频(文件类型为视频)
  /// 入参视频文件，返回压缩后的视频路径
  static Future<MediaInfo?> compressVideo(File? file) async {
    if (file != null) {
      try {
        // await VideoCompress.setLogLevel(0);
        MediaInfo? info = await VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
          includeAudio: true,
        );
        return info;
      } catch (e) {
        _log('压缩文件失败');
        return null;
      }
    } else {
      ToastUtil.show("压缩文件不存在");
      return null;
    }
  }

  /// 获取文件缩略图
  static Future<File?> getFileThumbnail(File? file) async {
    if (file != null) {
      try {
        if (Platform.isAndroid) {
          String? path = await VideoThumbnail.thumbnailFile(
            video: file.path,
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.JPEG,
            quality: 50,
          );
          if (TextUtil.isEmpty(path)) return null;
          return File(path!);
        } else {
          final thumbnailFile = await VideoCompress.getFileThumbnail(file.path,
              quality: 50, // default(100)
              position: -1 // default(-1)
              );
          return thumbnailFile;
        }
      } catch (e) {
        _log('获取缩略图失败');
        return null;
      }
    } else {
      ToastUtil.show("文件不存在");
      return null;
    }
  }

  /// 获取视频文件信息
  static Future<MediaInfo?> getMediaInfo(String videoPath) async {
    try {
      MediaInfo info = await VideoCompress.getMediaInfo(videoPath);
      return info;
    } catch (e) {
      _log('获取文件信息失败');
      return null;
    }
  }

  //构建FormData
  static FormData buildFormData(String filePath, filename, UploadFileOssEntity _uploadFileOssEntity) {
    return FormData.fromMap({
      'Filename': filename, //文件名，随意
      'file': MultipartFile.fromFileSync(filePath, filename: filename),
      'key': _uploadFileOssEntity.dir! + "/" + filename,
      'policy': _uploadFileOssEntity.policy,
      'OSSAccessKeyId': _uploadFileOssEntity.accessid,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': _uploadFileOssEntity.signature
    });
  }

  ///获取服务员上传图片地址
  static Future<UploadFileOssEntity?> getUploadImgInfo(BuildContext context) async {
    GetOssUrlApi api = GetOssUrlApi(context);
    return api.start(params: {}).then((res) {
      if (res.success != null && res.success!) {
        return res.result;
      } else {
        ToastUtil.show(res.message);
        return null;
      }
    });
  }

  ///上传图片到阿里服务器
  static Future<Response?> uploadImgToAli(String path, FormData data) async {
    return await DioUploadUtil.uploadFile(path, data: data);
  }

  /// 上传文件
  static Future<List<CustomMessageFileEntity>> uploadFiles(
    BuildContext context,
    List<File> files,
    RikiFileUploadType uploadType, {
    OnConfiguringOss? configuringOss,
    String? uuid,
    bool toast = true,
  }) async {
    _log('上传文件类型为$uploadType');
    List<CustomMessageFileEntity> ossPaths = [];

    for (File file in files) {
      //从路径中获取到文件的名称拼成OSS服务中的新名字
      var fileEntity = CustomMessageFileEntity();
      fileEntity.filePath = file.path;
      ossPaths.add(fileEntity);
      if (uuid != null) {
        fileEntity.uuid = uuid;
      }
      UploadFileOssEntity? uploadFileOssEntity = configuringOss != null ? await configuringOss() : await getUploadImgInfo(context);
      if (uploadFileOssEntity == null) {
        //获取oss配置失败
        _log('获取oss配置失败');
        continue;
      }
      _log('oss配置信息');
      _log('$uploadFileOssEntity');
      String showFilename = RikiFileUtil.getFileNameOfPath(file.path);
      if (showFilename == null || !showFilename.contains('.')) {
        ToastUtil.show('请上传正确格式文件');
        continue;
      }
      String upLoadFileName = getUpLoadOssFileName(showFilename);
      String? ossVideoThumbnailPath; //视频缩略图在OSS中的存储路径
      if (uploadType == RikiFileUploadType.IMAGE) {
        //如果是图片的话需要压缩
        _log('图片文件压缩中...');
        file = await ImageCompressUtils.imageCompressAndGetFile(file) ?? file;
        _log('图片文件压缩完成');
      } else if (uploadType == RikiFileUploadType.VIDEO) {
        //如果是视频的话 需要获取首帧图，上传到OSS服务中
        File? thumbnailFile = await getFileThumbnail(file);
        if (thumbnailFile != null) {
          String locVideoThumbnailPath = thumbnailFile.path; //视频的本地首帧缩略图存放的路径
          String videoThumbnailName = RikiFileUtil.getFileNameOfPath(locVideoThumbnailPath);
          var videoThumbnailData = buildFormData(locVideoThumbnailPath, videoThumbnailName, uploadFileOssEntity);
          //上传缩略图
          Response? response = await uploadImgToAli(uploadFileOssEntity.host!, videoThumbnailData);
          if (response?.statusCode == 200) {
            ossVideoThumbnailPath = uploadFileOssEntity.ossUrl! + videoThumbnailName;
            _log('上传视频首帧图到OSS服务器成功');
          } else {
            _log('上传视频首帧图到OSS服务器失败');
          }
        }
        //压缩视频文件
        _log('视频文件压缩中...');
        //RikiLoading.show(context, hintText: '视频处理中...');
        MediaInfo? info = await compressVideo(file);
        if (info == null) {
          ToastUtil.show('压缩视频失败');
          continue;
        }
        file = info.file!;
        //RikiLoading.hide();
        _log('视频文件压缩完成');
      }

      _log('获取oss路径成功，准备存储文件');
      //获取iOS应用的绝对路径
      String newPath;
      if (Platform.isAndroid) {
        newPath = file.path;
      } else {
        newPath = RikiFileUtil.getAbsolutePath(file.path);
      }
      var data = buildFormData(newPath, upLoadFileName, uploadFileOssEntity);
      _log('构建文件数据FormData成功');
      Response? response = await uploadImgToAli(uploadFileOssEntity.host!, data);
      _log('准备上传');
      if (response?.statusCode == 200) {
        _log('上传成功');
        String ossPath = uploadFileOssEntity.ossUrl! + upLoadFileName;
        fileEntity.fileSize = File(newPath).lengthSync();
        if (uploadType == RikiFileUploadType.VIDEO) {
          fileEntity.videoThumbnailUrl = ossVideoThumbnailPath;
        }
        fileEntity.fileName = showFilename;
        fileEntity.fileUrl = ossPath;
        fileEntity.localPath = newPath;
        fileEntity.fileStatus = CustomMessageFileStatus.success;
      } else {
        _log('上传失败');
        if (toast) {
          ToastUtil.show("上传失败");
        }
      }
    }
    return ossPaths;
  }

  ///发送文件--->图片类型
  static Future<CustomMessageFileEntity> sendFileOfImg(
    BuildContext context,
    String imgPath,
    String uuid, {
    OnConfiguringOss? configuringOss,
  }) async {
    List<CustomMessageFileEntity> files =
        await uploadFiles(context, [File(imgPath)], RikiFileUploadType.IMAGE, uuid: uuid, configuringOss: configuringOss);
    return files.first;
  }

  ///发送文件--->视频类型
  static Future<CustomMessageFileEntity> sendFileOfVideo(
    BuildContext context,
    String videoPath,
    String uuid, {
    OnConfiguringOss? configuringOss,
  }) async {
    List<CustomMessageFileEntity> files =
        await uploadFiles(context, [File(videoPath)], RikiFileUploadType.VIDEO, uuid: uuid, configuringOss: configuringOss);
    return files.first;
  }

  ///发送文件--->文件类型
  static Future<CustomMessageFileEntity> sendFileOfFile(
    BuildContext context,
    String filePath,
    String uuid, {
    OnConfiguringOss? configuringOss,
  }) async {
    List<CustomMessageFileEntity> files =
        await uploadFiles(context, [File(filePath)], RikiFileUploadType.NORMAL, uuid: uuid, configuringOss: configuringOss);
    return files.first;
  }
}
