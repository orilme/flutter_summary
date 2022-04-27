import 'dart:async';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter_demo/base/utils/log_util.dart';
import 'package:flutter_demo/base/utils/sp_util.dart';
import 'package:flutter_demo/base/utils/text_util.dart';

import 'riki_download_cache_manager.dart';
import 'riki_default_cache_manager.dart';
import 'riki_default_file_system.dart';
import 'riki_file_system.dart';
import '../entity/local_file_entity.dart';

class RikiFileUtil {
  static const String _DOWNLOAD = '下载';

  static const String SERVICE_GROUP_PATH = '群沟通';
  static const String SERVICE_GROUP_PATH_IMG = '图片';
  static const String SERVICE_GROUP_PATH_VIDEO = '视频';
  static const String SERVICE_GROUP_PATH_FILE = '文件';
  static const String SERVICE_GROUP_PATH_SOUND = '语音';

  static const String FINALIZED_FILE_PATH = '定稿文件';
  static const String DELIVERY_FILE_PATH = '交付文件';

  static void init() {
    findLocalPath().then((value) {
      localPath = value;
    });
  }

  static late String localPath;

  /// 获取沙盒存储路径
  static Future<String> findLocalPath() async {
    // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
    // 如果是android，使用getExternalStorageDirectory
    // 如果是iOS，使用getApplicationSupportDirectory
    try {
      final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getLibraryDirectory();
      if (directory == null) throw Exception();
      return directory.path;
    } catch (e) {
      LogUtil.v('获取存储路径失败');
      return '';
    }
  }

  /// 获取android sd卡路径
  static Future<String> findAndroidSdLocalPath() async {
    // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
    // 如果是android，使用getExternalStorageDirectory
    // 如果是iOS，使用getApplicationSupportDirectory
    try {
      var result = Platform.isAndroid ? await ExtStorage.getExternalStorageDirectory() : null;
      return result ?? '';
    } catch (e) {
      LogUtil.v('获取存储路径失败');
      return '';
    }
  }

  /// ---------------------------------------------------------------------iOS 单独使用方法 -----------------------------------------------------------
  /// 保存本地文件信息到SP
  static const String LOCAL_FILE_ENTITIES = 'local_file_entities';

  ///获取本地打扮家文件夹路径
  static Future<String> daBanJiaDirectory() async {
    String localPath = await findLocalPath();
    return localPath + '/dabanjia';
  }

  ///把文件信息实体存储在SP中 (only iOS)
  static Future<bool> storeLocFileEntity(LocalFileEntity localFileEntity) async {
    List<LocalFileEntity> fileEntities =
        SpUtil.getObjList<LocalFileEntity>(LOCAL_FILE_ENTITIES, (v) => LocalFileEntity.fromJson(v == null ? {} : v as Map<String, dynamic>));
    if (fileEntities.isEmpty) {
      fileEntities = [];
    }
    fileEntities.add(localFileEntity);
    //是否存储成功 异步存储后返回结果
    bool storeSuccess = await SpUtil.putObjectList(LOCAL_FILE_ENTITIES, fileEntities);
    return storeSuccess;
  }

  ///从SP中取出本地文件信息entity的集合 (only iOS)
  static List<LocalFileEntity> getLocFileEntities() {
    List<LocalFileEntity> fileEntities =
        SpUtil.getObjList<LocalFileEntity>(LOCAL_FILE_ENTITIES, (v) => LocalFileEntity.fromJson(v == null ? {} : v as Map<String, dynamic>));
    return fileEntities;
  }

  // ///获取打扮家文件下的所有文件(only iOS 此方法有问题暂时不支持使用)
  // static _getDirectoryFiles(String directoryPath, List<FileSystemEntity> files) {
  //   try {
  //     var directory = Directory(directoryPath); //获取到目录对象
  //     files = directory.listSync(); //目录下的文件集合
  //     for (var f in files) {
  //       //打印文件名或者文件夹名
  //       var bool = FileSystemEntity.isFileSync(f.path);
  //       if (!bool) {
  //         //如果是文件夹继续遍历
  //         _log("本地打扮家文件夹路径" + directoryPath);
  //         _getDirectoryFiles(f.path, files);
  //       } else {
  //         //如果是具体的文件，存入
  //         _log("本地打扮家文件为" + f.path); //打印文件名或者文件夹名
  //         files.add(f);
  //       }
  //     }
  //   } catch (e) {
  //     _log('文件夹路径不正确!');
  //   }
  // }

  /// 返回一个本地文件的绝对路径(由于iOS每次重装app,沙盒的绝对路径都会变化，所以需要把本地存储的原有文件的路径转为最新的绝对路径)
  ////var/mobile/Containers/Data/Application/365EAEDC-14AA-49C8-8040-4A334DA87DB2/Library/dabanjia/2020-11-2418:48:16/APP(IOSAndroid)计划已编辑完成.xlsx
  static String getAbsolutePath(String oldPath) {
    if (TextUtil.isEmpty(oldPath)) {
      return oldPath;
    }
    if (oldPath.contains('Library')) {
      String endPath = oldPath.split('Library').last;
      String libraryPath = localPath;
      String newPath = libraryPath + endPath;
      return newPath;
    } else {
      return oldPath;
    }
  }

  ///获取路径中的名字
  static String getFileNameOfPath(String path) {
    if (!TextUtil.isEmpty(path)) {
      return RikiFileUtil.getLocalFileName(path);
    }
    return '';
  }

  /// 获取文件名
  /// [file] xxxxx.jpg xxxx.mp3
  /// return xxxx
  static String getFileName(String file) {
    if (!file.contains('.')) {
      return file;
    }
    return file.substring(0, file.lastIndexOf('.'));
  }

  /// 获取本地文件名称
  /// [path] /xxx/xxx/xxxx.jpg
  /// return xxxx
  static String getLocalFileName(String path) {
    if (!path.contains('/')) return path;
    return path.split('/').last;
  }

  /// 获取网络文件名称
  /// [path] /xxx/xxx/xxxx.jpg
  /// return xxxx
  static String getUrlFileName(String path) {
    if (path.contains('/')) path = path.split('/').last;
    return path.contains('?') ? path.substring(0, path.indexOf('?')) : path;
  }

  /// 获取文件类型
  /// [file] xxxxx.jpg
  /// return jpg
  static String getFileType(String file) {
    if (TextUtil.isEmpty(file)) return '';
    if (!file.contains('.')) {
      return file;
    }
    String type = file.substring(file.lastIndexOf('.') + 1);
    return type.contains('?') ? type.substring(0, type.indexOf('?')) : type;
  }

  /// 下载文件，无进度
  /// [url] 网络路径
  /// [type] 文件类型 如：jpg
  /// [fileName] 文件名 如：riki_file_util
  /// [externalStorage] 是否外部存储 默认true 仅Android生效
  static Future<File> downloadFile(
    String url,
    String type, {
    String? fileName,
    String fileDir = _DOWNLOAD,
    bool externalStorage = true,
  }) async {
    Map<String, String> headers = Map();
    headers['file-type'] = type;
    if (!TextUtil.isEmpty(fileName)) {
      fileName = getFileName(fileName!);
    } else {
      fileName = getLocalFileName(url);
    }
    headers['file-name'] = Uri.encodeComponent('$fileDir/$fileName');

    if (externalStorage) {
      return RikiDownloadCacheManager().getSingleFile(url, key: TextUtil.md5(url), headers: headers);
    }
    return RikiDefaultCacheManager().getSingleFile(url, key: TextUtil.md5(url), headers: headers);
  }

  /// 下载文件，有进度
  /// [url] 网络路径
  /// [type] 文件类型 如：jpg
  /// [fileName] 文件名 如：riki_file_util
  /// [withProgress] 是否开启进度监听 默认true FileResponse => DownloadProgress ,false FileResponse
  /// [externalStorage] 是否外部存储 默认true 仅Android生效
  static Stream<FileResponse> downloadFileStream(
    String url,
    String type, {
    String? fileName,
    String fileDir = _DOWNLOAD,
    bool withProgress = true,
    bool externalStorage = true,
  }) {
    Map<String, String> headers = Map();
    headers['file-type'] = type;
    if (!TextUtil.isEmpty(fileName)) {
      fileName = getFileName(fileName!);
    } else {
      fileName = getLocalFileName(url);
    }
    headers['file-name'] = Uri.encodeComponent('$fileDir/$fileName');

    if (externalStorage) {
      return RikiDownloadCacheManager().getFileStream(url, key: TextUtil.md5(url), headers: headers, withProgress: withProgress);
    }
    return RikiDefaultCacheManager().getFileStream(url, key: TextUtil.md5(url), headers: headers, withProgress: withProgress);
  }

  /// 获取缓存文件信息
  /// [url] 网络路径
  /// [externalStorage] 是否外部存储 默认true 仅Android生效
  static Future<FileInfo?> getFileInfoFormCache(
    String url, {
    bool externalStorage = true,
  }) {
    if (externalStorage) {
      return RikiDownloadCacheManager().getFileFromCache(TextUtil.md5(url));
    }
    return RikiDefaultCacheManager().getFileFromCache(TextUtil.md5(url));
  }

  /// 删除文件
  /// [url] 网络路径
  /// [externalStorage] 是否外部存储 默认true 仅Android生效
  static removeFile(
    String url, {
    bool externalStorage = true,
  }) {
    if (externalStorage) {
      return RikiDownloadCacheManager().removeFile(TextUtil.md5(url));
    }
    return RikiDefaultCacheManager().removeFile(TextUtil.md5(url));
  }

  // 获取保存路径
  static Future<String?> getSavePath({
    bool full = true,
    bool externalStorage = true,
    String groupId = '',
    String modulePath = SERVICE_GROUP_PATH,
    String? dirName,
    String? fileName,
  }) async {
    String? path = getSaveDir(groupId: groupId, modulePath: modulePath, dirName: dirName);
    if (full) {
      if (externalStorage) {
        RikiFileSystem fileSystem = RikiFileSystem(RikiDownloadCacheManager.key);
        path = await fileSystem.createPath(path);
      } else {
        RikiDefaultFileSystem fileSystem = RikiDefaultFileSystem(RikiDefaultCacheManager.key);
        path = await fileSystem.createPath(path);
      }
    }
    if (TextUtil.isEmpty(fileName)) {
      return path;
    }
    if (path == null) return '';
    return path + '/' + fileName!;
  }

  static String getSaveDir({
    String groupId = '',
    String modulePath = SERVICE_GROUP_PATH,
    String? dirName,
  }) {
    String savePath = modulePath;
    if (!TextUtil.isEmpty(dirName)) {
      savePath = savePath + '/' + dirName!;
    }
    if (!TextUtil.isEmpty(groupId)) {
      return savePath + '/' + TextUtil.md5(groupId);
    }
    return savePath;
  }

  /// remove后需调用
  static reset() {
    RikiDefaultCacheManager.reset();
    RikiDownloadCacheManager.reset();
  }

  static const RollupSize_Units = ["GB", "MB", "KB", "B"];

  // 返回文件大小字符串 单位kb
  static String getRollupSize(int size) {
    if (size == null || size <= 0) return '';
//    size = size * 1024;
    int idx = 3;
    int r1 = 0;
    String result = "";
    while (idx >= 0) {
      int s1 = size % 1024;
      size = size >> 10;
      if (size == 0 || idx == 0) {
        r1 = (r1 * 100) ~/ 1024;
        if (r1 > 0) {
          if (r1 >= 10)
            result = "$s1.$r1${RollupSize_Units[idx]}";
          else
            result = "$s1.0$r1${RollupSize_Units[idx]}";
        } else
          result = s1.toString() + RollupSize_Units[idx];
        break;
      }
      r1 = s1;
      idx--;
    }
    return result;
  }

  /// 打开文件
  static openFile(String filePath) async {
    if (TextUtil.isEmpty(filePath)) {
      print('文件不存在!');
    }
    try {
      final result = await OpenFile.open(filePath);
      LogUtil.v(result);
    } catch (e) {
      LogUtil.v('打开文件失败' + e.toString());
    }
  }
}
