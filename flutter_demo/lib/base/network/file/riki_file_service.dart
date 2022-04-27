import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:clock/clock.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/web/mime_converter.dart';

/// [RikiHttpFileService] is the most common file service and the default for
/// [WebHelper]. One can easily adapt it to use dio or any other http client.
class RikiHttpFileService extends FileService {
  late http.Client _httpClient;
  RikiHttpFileService({http.Client? httpClient}) {
    _httpClient = httpClient ?? http.Client();
  }

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers = const {}}) async {
    final req = http.Request('GET', Uri.parse(url));
    req.headers.addAll(headers!);
    final httpResponse = await _httpClient.send(req);

    return RikiHttpGetResponse(httpResponse);
  }
}

/// Basic implementation of a [FileServiceResponse] for http requests.
class RikiHttpGetResponse implements FileServiceResponse {
  RikiHttpGetResponse(this._response);

  final DateTime _receivedTime = clock.now();

  final http.StreamedResponse _response;

  http.StreamedResponse get response => _response;

  @override
  int get statusCode => _response.statusCode;

  bool _hasHeader(String name) {
    return _response.headers.containsKey(name);
  }

  String? _header(String name) {
    return _response.headers[name];
  }

  @override
  Stream<List<int>> get content => _response.stream;

  @override
  int? get contentLength => _response.contentLength;

  @override
  DateTime get validTill {
    // Without a cache-control header we keep the file for a week
    var ageDuration = const Duration(days: 7);
    if (_hasHeader(HttpHeaders.cacheControlHeader)) {
      final controlSettings = _header(HttpHeaders.cacheControlHeader)!.split(',');
      for (final setting in controlSettings) {
        final sanitizedSetting = setting.trim().toLowerCase();
        if (sanitizedSetting == 'no-cache') {
          ageDuration = const Duration();
        }
        if (sanitizedSetting.startsWith('max-age=')) {
          var validSeconds = int.tryParse(sanitizedSetting.split('=')[1]) ?? 0;
          if (validSeconds > 0) {
            ageDuration = Duration(seconds: validSeconds);
          }
        }
      }
    }

    return _receivedTime.add(ageDuration);
  }

  @override
  String? get eTag => _hasHeader(HttpHeaders.etagHeader) ? _header(HttpHeaders.etagHeader)! : null;

  @override
  String get fileExtension {
    var fileExtension = '';
    if (_hasHeader(HttpHeaders.contentTypeHeader)) {
      var contentType = ContentType.parse(_header(HttpHeaders.contentTypeHeader)!);
      fileExtension = contentType.fileExtension;
    }
    return fileExtension;
  }
}
