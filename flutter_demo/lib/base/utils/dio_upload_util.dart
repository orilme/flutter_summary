import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riki_http/riki_http.dart' as JvtdHttp;

///
/// Dio文件上传工具类
///
/// Created by Jack Zhang on 12/29/20 .
///
class DioUploadUtil {
  /// 上传文件
  static Future<Response?> uploadFile(path, {required FormData data}) async {
    Response? response;
    try {
      Dio dio = JvtdHttp.dio;
      dio.options.contentType = "image/jpg";
      dio.options.headers = {"content-disposition": "inline"};
      response = await dio.post(path, data: data, onReceiveProgress: (int count, int total) {
        debugPrint('onReceiveProgress: ${(count / total * 100).toStringAsFixed(0)} %');
      }, onSendProgress: (int count, int total) {
        debugPrint('onSendProgress: ${(count / total * 100).toStringAsFixed(0)} %');
      });
    } on DioError catch (e) {
      response?.statusCode = e.response?.statusCode;
    }
    return response;
  }
}
