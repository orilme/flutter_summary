import 'dart:io' show Platform;

import 'package:file/file.dart' hide FileSystem;
import 'package:file/local.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart' as c;
import 'package:ext_storage/ext_storage.dart';
import 'package:package_info/package_info.dart';

class RikiFileSystem implements c.FileSystem {
  final Future<Directory> _fileDir;
  final String _cacheKey;

  RikiFileSystem(this._cacheKey) : _fileDir = createDirectory(_cacheKey);

  static Future<Directory> createDirectory(String key) async {
    var path;
    if (Platform.isAndroid) {
      String? externalDir = await ExtStorage.getExternalStorageDirectory();
      if(externalDir == null){
        externalDir = (await getTemporaryDirectory()).path;
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      path = p.join(externalDir, packageInfo.appName);
    } else {
      var baseDir = await getApplicationDocumentsDirectory();
      path = p.join(baseDir.path, key);
    }
    var fs = const LocalFileSystem();
    var directory = fs.directory((path));
    await directory.create(recursive: true);
    return directory;
  }

  Future<String?> createPath(String? path) async {
    if (path == null || path.trim() == '') return null;
    var directory = (await _fileDir);
    if (!(await directory.exists())) {
      await createDirectory(_cacheKey);
    }
    path = p.join(directory.path, path);
    var fs = const LocalFileSystem();
    var dir = fs.directory((path));
    await dir.create(recursive: true);
    return path;
  }

  @override
  Future<File> createFile(String name) async {
    var directory = (await _fileDir);
    if (!(await directory.exists())) {
      await createDirectory(_cacheKey);
    }
    if (name.contains('/')) {
      String path = name.substring(0, name.lastIndexOf('/'));
      path = p.join(directory.path, path);
      var fs = const LocalFileSystem();
      var dir = fs.directory((path));
      await dir.create(recursive: true);
    }
    return (await _fileDir).childFile(name);
  }
}
