import 'riki_default_file_system.dart';
import 'riki_file_cache_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'riki_file_service.dart';

class RikiDefaultCacheManager extends RikiFileCacheManager {
  static const key = 'defaultCache';

  static RikiDefaultCacheManager? _instance;

  factory RikiDefaultCacheManager() {
    _instance ??= RikiDefaultCacheManager._();
    return _instance!;
  }

  static reset() {
    _instance = null;
  }

  RikiDefaultCacheManager._() : super(Config(key, fileService: RikiHttpFileService(), fileSystem: RikiDefaultFileSystem(key)));
}
