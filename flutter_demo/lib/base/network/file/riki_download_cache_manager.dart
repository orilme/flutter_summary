import 'riki_file_cache_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'riki_file_service.dart';
import 'riki_file_system.dart';

class RikiDownloadCacheManager extends RikiFileCacheManager {
  static const key = 'download';

  static RikiDownloadCacheManager? _instance;

  factory RikiDownloadCacheManager() {
    _instance ??= RikiDownloadCacheManager._();
    return _instance!;
  }

  static reset(){
    _instance = null;
  }

  RikiDownloadCacheManager._() : super(Config(key, fileService: RikiHttpFileService(),fileSystem: RikiFileSystem(key)));
}
