import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:flutter_demo/base/utils/toast/toast_util.dart';
import 'package:flutter_demo/base/utils/text_util.dart';

class ImageSaveUtil {
  /// 保存图片
  /// [url] 网络地址
  static Future save(String url) async {
    dio.Response response = await dio.Dio().get(url, options: dio.Options(responseType: dio.ResponseType.bytes));
    if (response != null) {
      var result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 100);
      return result;
    }
    return null;
  }

  /// 保存图片到本地相册
  /// [imageString] 本地图片base64字符串
  static void saveLocalImage(String base64String) async {
    //LogUtil.v('base64String的长度 ${base64String.length}');
    if (!TextUtil.isEmpty(base64String)) {
      List<String> list = base64String.split(",");
      String resultString = '';
      if (list.length == 2) {
        resultString = list[1];
      }
      //LogUtil.v('resultString ==== $resultString');
      Uint8List bytes = base64.decode(resultString);
      var result = await ImageGallerySaver.saveImage(bytes, quality: 100);
      if (result == null || !result['isSuccess']) {
        ToastUtil.show('保存失败，请重试～');
      } else {
        ToastUtil.show('已保存到系统相册');
        var savedFile = File.fromUri(Uri.file(result['filePath']));
        //刷新
        Future<File>.sync(() => savedFile);
      }
    }
  }
}
