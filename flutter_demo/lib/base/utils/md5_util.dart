import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

/// MD5工具类

class Md5Util {
  /// md5 加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
