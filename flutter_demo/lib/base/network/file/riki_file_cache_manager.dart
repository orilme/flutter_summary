import 'dart:async';
import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// ignore: implementation_imports
import 'package:flutter_cache_manager/src/cache_managers/base_cache_manager.dart';

// ignore: implementation_imports
import 'package:flutter_cache_manager/src/cache_store.dart';

// ignore: implementation_imports
import 'package:flutter_cache_manager/src/result/download_progress.dart';

// ignore: implementation_imports
import 'package:flutter_cache_manager/src/result/file_info.dart';

// ignore: implementation_imports
import 'package:flutter_cache_manager/src/result/file_response.dart';

// ignore: implementation_imports
import 'package:flutter_cache_manager/src/storage/cache_object.dart';

// ignore: implementation_imports
import 'package:flutter_cache_manager/src/web/web_helper.dart';
import 'package:pedantic/pedantic.dart';
import 'package:uuid/uuid.dart';

import 'riki_web_helper.dart';

class RikiFileCacheManager implements BaseCacheManager {
  RikiFileCacheManager(Config config) {
    _config = config;
    _store = CacheStore(config);
    _webHelper = RikiWebHelper(_store, config.fileService);
  }

  late Config _config;

  /// Store helper for cached files
  late CacheStore _store;

  /// Get the underlying store helper
  CacheStore get store => _store;

  /// WebHelper to download and store files
  late RikiWebHelper _webHelper;

  /// Get the underlying web helper
  RikiWebHelper get webHelper => _webHelper;

  Map<String, String>? _headers;

  /// Get the file from the cache and/or online, depending on availability and age.
  /// Downloaded form [url], [headers] can be used for example for authentication.
  /// When a file is cached it is return directly, when it is too old the file is
  /// downloaded in the background. When a cached file is not available the
  /// newly downloaded file is returned.
  @override
  Future<File> getSingleFile(
    String url, {
    String? key,
    Map<String, String>? headers,
  }) async {
    key ??= url;
    _headers = headers;
    final cacheFile = await getFileFromCache(key);
    if (cacheFile != null) {
      if (cacheFile.validTill.isBefore(DateTime.now())) {
        unawaited(downloadFile(url, key: key, authHeaders: headers));
      }
      return cacheFile.file;
    }
    return (await downloadFile(url, key: key, authHeaders: headers)).file;
  }

  /// Get the file from the cache and/or online, depending on availability and age.
  /// Downloaded form [url], [headers] can be used for example for authentication.
  /// The files are returned as stream. First the cached file if available, when the
  /// cached file is too old the newly downloaded file is returned afterwards.
  @override
  @Deprecated('Prefer to use the new getFileStream method')
  Stream<FileInfo> getFile(String url, {String? key, Map<String, String>? headers}) {
    _headers = headers;
    return getFileStream(
      url,
      key: key,
      headers: headers,
      withProgress: false,
    ).where((r) => r is FileInfo).cast<FileInfo>();
  }

  /// Get the file from the cache and/or online, depending on availability and age.
  /// Downloaded form [url], [headers] can be used for example for authentication.
  /// The files are returned as stream. First the cached file if available, when the
  /// cached file is too old the newly downloaded file is returned afterwards.
  ///
  /// The [FileResponse] is either a [FileInfo] object for fully downloaded files
  /// or a [DownloadProgress] object for when a file is being downloaded.
  /// The [DownloadProgress] objects are only dispatched when [withProgress] is
  /// set on true and the file is not available in the cache. When the file is
  /// returned from the cache there will be no progress given, although the file
  /// might be outdated and a new file is being downloaded in the background.
  @override
  Stream<FileResponse> getFileStream(String url, {String? key, Map<String, String>? headers, bool? withProgress}) {
    key ??= url;
    _headers = headers;
    final streamController = StreamController<FileResponse>();
    _pushFileToStream(streamController, url, key, headers, withProgress ?? false);
    return streamController.stream;
  }

  Future<void> _pushFileToStream(StreamController streamController, String url, String? key, Map<String, String>? headers, bool withProgress) async {
    key ??= url;
    FileInfo? cacheFile;
    try {
      cacheFile = await getFileFromCache(key);
      if (cacheFile != null) {
        streamController.add(cacheFile);
        withProgress = false;
      }
    } catch (e) {
      print('CacheManager: Failed to load cached file for $url with error:\n$e');
    }
    if (cacheFile == null || cacheFile.validTill.isBefore(DateTime.now())) {
      try {
        await for (var response in _webHelper.downloadFile(url, key: key, authHeaders: headers)) {
          if (response is DownloadProgress && withProgress) {
            streamController.add(response);
          }
          if (response is FileInfo) {
            streamController.add(response);
          }
        }
      } catch (e) {
        assert(() {
          print('CacheManager: Failed to download file from $url with error:\n$e');
          return true;
        }());
        if (cacheFile == null && streamController.hasListener) {
          streamController.addError(e);
        }
      }
    }
    unawaited(streamController.close());
  }

  ///Download the file and add to cache
  @override
  Future<FileInfo> downloadFile(String url, {String? key, Map<String, String>? authHeaders, bool force = false}) async {
    key ??= url;
    _headers = authHeaders;
    var fileResponse = await _webHelper
        .downloadFile(
          url,
          key: key,
          authHeaders: authHeaders,
          ignoreMemCache: force,
        )
        .firstWhere((r) => r is FileInfo);
    return fileResponse as FileInfo;
  }

  /// Get the file from the cache.
  /// Specify [ignoreMemCache] to force a re-read from the database
  @override
  Future<FileInfo?> getFileFromCache(String key, {bool ignoreMemCache = false}) => _store.getFile(key, ignoreMemCache: ignoreMemCache);

  ///Returns the file from memory if it has already been fetched
  @override
  Future<FileInfo?> getFileFromMemory(String key) => _store.getFileFromMemory(key);

  /// Put a file in the cache. It is recommended to specify the [eTag] and the
  /// [maxAge]. When [maxAge] is passed and the eTag is not set the file will
  /// always be downloaded again. The [fileExtension] should be without a dot,
  /// for example "jpg". When cache info is available for the url that path
  /// is re-used.
  /// The returned [File] is saved on disk.
  @override
  Future<File> putFile(
    String url,
    Uint8List fileBytes, {
    String? key,
    String? eTag,
    Duration maxAge = const Duration(days: 30),
    String fileExtension = 'file',
  }) async {
    key ??= url;
    CacheObject? cacheObject = await _store.retrieveCacheData(key);

    String fileName = Uuid().v1();
    String fileType = fileExtension;

    if (_headers != null && _headers!.isNotEmpty) {
      if (_headers!.containsKey('file-name')) {
        fileName = Uri.decodeComponent(_headers!['file-name']!);
      }
      if (_headers!.containsKey('file-type')) {
        fileType = '.${_headers!['file-type']}';
      }
    }

    cacheObject ??= CacheObject(url, key: key, relativePath: '$fileName.$fileType'
                  ,validTill: DateTime.now().add(Duration(days: 180)));

    cacheObject = cacheObject.copyWith(
      validTill: DateTime.now().add(maxAge),
      eTag: eTag,
    );

    final file = await _config.fileSystem.createFile(cacheObject.relativePath);
    await file.writeAsBytes(fileBytes);
    unawaited(_store.putFile(cacheObject));
    return file;
  }

  /// Put a byte stream in the cache. When using an existing file you can use
  /// file.openRead(). It is recommended to specify  the [eTag] and the
  /// [maxAge]. When [maxAge] is passed and the eTag is not set the file will
  /// always be downloaded again. The [fileExtension] should be without a dot,
  /// for example "jpg". When cache info is available for the url that path
  /// is re-used.
  /// The returned [File] is saved on disk.
  @override
  Future<File> putFileStream(
    String url,
    Stream<List<int>> source, {
    String? key,
    String? eTag,
    Duration maxAge = const Duration(days: 30),
    String fileExtension = 'file',
  }) async {
    key ??= url;
    var cacheObject = await _store.retrieveCacheData(key);
    String fileName = Uuid().v1();
    String fileType = fileExtension;

    if (_headers != null && _headers!.isNotEmpty) {
      if (_headers!.containsKey('file-name')) {
        fileName = Uri.decodeComponent(_headers!['file-name']!);
      }
      if (_headers!.containsKey('file-type')) {
        fileType = '.${_headers!['file-type']}';
      }
    }
    cacheObject ??= CacheObject(url, key: key, relativePath: '$fileName.$fileType'
                ,validTill: DateTime.now().add(Duration(days: 180)));

    cacheObject = cacheObject.copyWith(
      validTill: DateTime.now().add(maxAge),
      eTag: eTag,
    );

    var file = await _config.fileSystem.createFile(cacheObject.relativePath);

    // Always copy file
    var sink = file.openWrite();
    await source
        // this map is need to map UInt8List to List<int>
        .map((event) => event)
        .pipe(sink);

    unawaited(_store.putFile(cacheObject));
    return file;
  }

  /// Remove a file from the cache
  @override
  Future<void> removeFile(String key) async {
    final cacheObject = await _store.retrieveCacheData(key);
    if (cacheObject != null) {
      await _store.removeCachedFile(cacheObject);
    }
  }

  /// Removes all files from the cache
  @override
  Future<void> emptyCache() => _store.emptyCache();

  /// Closes the cache database
  @override
  Future<void> dispose() async {
    await _config.repo.close();
  }
}
