import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import 'riki_file_util.dart';
import 'package:flutter_demo/base/utils/log_util.dart';
import 'package:flutter_demo/base/utils/text_util.dart';

class DownloadProgressChangedNotifier with ChangeNotifier {
  Map<String, RikiDownloadProgressEntity> downloadCacheMap = Map<String, RikiDownloadProgressEntity>();

  void downloadProgressChanged(RikiDownloadProgressEntity entity) {
    downloadCacheMap[entity.markId] = entity;
    notifyListeners();
  }
}

enum DownloadStatus {
  none, // 无状态
  downloading, // 下载中
  downloaded, // 已下载
  downloadFailed, // 下载失败
}

class RikiDownloadProgressEntity {
  String markId;
  String savePath; //只有下载完成后才会是本地路径
  double progress;
  DownloadStatus status;

  RikiDownloadProgressEntity({
    required this.markId,
    required this.savePath,
    required this.progress,
    required this.status,
  });
}

class RikiDownloadUtil {
  factory RikiDownloadUtil() => _getInstance()!;

  static RikiDownloadUtil? get instance => _getInstance();
  static RikiDownloadUtil? _instance;

  RikiDownloadUtil._internal();

  static RikiDownloadUtil? _getInstance() {
    if (_instance == null) {
      _instance = new RikiDownloadUtil._internal();
    }
    return _instance;
  }

  static const String _TAG = 'RikiDownloadUtil';

  void _log(Object msg) {
    LogUtil.v(msg, tag: _TAG);
  }

  /// 根据url获取key
  String _downloadKey(String url) {
    return TextUtil.md5(url);
  }

  Map<String, StreamSubscription<FileResponse>> _downloadManager = {};

  void cancelDownload(String url) {
    String key = _downloadKey(url);
    if (_downloadManager.containsKey(key)) {
      StreamSubscription<FileResponse> _fileResponse = _downloadManager[key]!;
      _fileResponse.cancel();
    }
  }

  /// 判断文件是否存在
  Future<bool> fileExist(
    String url, {
    bool externalStorage = true,
  }) async {
    return await RikiFileUtil.getFileInfoFormCache(url, externalStorage: externalStorage) != null;
  }

  /// 获取文件路径
  Future<String?> localFilePath(
    String url, {
    bool externalStorage = true,
  }) async {
    FileInfo? fileInfo = await RikiFileUtil.getFileInfoFormCache(url, externalStorage: externalStorage);
    return fileInfo?.file.path;
  }

  /// 下载文件
  Future<String?> download(
    BuildContext context,
    String markId,
    String url, {
    bool externalStorage = true,
    String? fileName,
    String groupId = '',
    String modulePath = RikiFileUtil.SERVICE_GROUP_PATH,
    String? dirName,
  }) async {
    Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
    if (!statuses[Permission.storage]!.isGranted) {
      print('-------请打开存储权限-------');
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("请打开存储权限"),
      ));
      return null;
    }

    String key = _downloadKey(url);
    Completer<String> completer = Completer<String>();
    DownloadProgressChangedNotifier notifier = Provider.of<DownloadProgressChangedNotifier>(context, listen: false);

    fileName ??= RikiFileUtil.getUrlFileName(url);
    String type = RikiFileUtil.getFileType(fileName);
    String fileDir = RikiFileUtil.getSaveDir(groupId: groupId, modulePath: modulePath, dirName: dirName);

    _log('$key   下载信息');
    _log('$key   名称：$fileName');
    _log('$key   类型：$type');
    _log('$key   保存文件夹：$fileDir');
    _log('$key   下载地址：$url');
    _log('$key   是否外部存储：$externalStorage');

    Stream<FileResponse> fileResponse =
        RikiFileUtil.downloadFileStream(url, type, fileName: fileName, externalStorage: externalStorage, fileDir: fileDir);
    _downloadManager[key] = fileResponse.listen((response) {
      if (response is FileInfo) {
        // 下载完成
        _log('$key   下载完成,路径在${response.file.path}');
        notifier.downloadProgressChanged(RikiDownloadProgressEntity(
          markId: markId,
          savePath: response.file.path,
          progress: 1.0,
          status: DownloadStatus.downloaded,
        ));
        completer.complete(response.file.path);
      } else if (response is DownloadProgress) {
        if (response != null && response.progress != null) {
          _log('$key   下载中,当前进度为${((response.progress ?? 0) * 100).toStringAsFixed(2)}%');
          notifier.downloadProgressChanged(RikiDownloadProgressEntity(
            markId: markId,
            savePath: url,
            progress: response.progress ?? 0,
            status: DownloadStatus.downloading,
          ));
        }
      }
    }, onError: (_) {
      // 下载失败
      _log('$key   下载失败,原因$_');
      notifier.downloadProgressChanged(RikiDownloadProgressEntity(
        markId: markId,
        savePath: url,
        progress: 0.0,
        status: DownloadStatus.downloadFailed,
      ));
      completer.complete(null);
    }, onDone: () {
      _log('$key   下载结束');
      _downloadManager.remove(key);
    });
    return completer.future;
  }
}
