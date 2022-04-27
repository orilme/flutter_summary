import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_demo/base/utils/log_util.dart';
import 'riki_file_util.dart';

/// 描述：图片压缩工具类

class ImageCompressUtils {
  /// 图片压缩 File -> File
  static Future<File?> imageCompressAndGetFile(File file) async {
    if (file.lengthSync() < 200 * 1024) {
      return file;
    }
    var quality = 100;
    if (file.lengthSync() > 4 * 1024 * 1024) {
      quality = 50;
    } else if (file.lengthSync() > 2 * 1024 * 1024) {
      quality = 60;
    } else if (file.lengthSync() > 1 * 1024 * 1024) {
      quality = 70;
    } else if (file.lengthSync() > 0.5 * 1024 * 1024) {
      quality = 80;
    } else if (file.lengthSync() > 0.25 * 1024 * 1024) {
      quality = 90;
    }
    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path + "/" + DateTime.now().millisecondsSinceEpoch.toString() + randomBit(10).toString() + ".jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      rotate: 0,
    );
    if (result == null) return null;

    LogUtil.v("压缩前：" + RikiFileUtil.getRollupSize(file.lengthSync()));
    LogUtil.v("压缩后：" + RikiFileUtil.getRollupSize(result.lengthSync()));

    return result;
  }

  /// 图片压缩 File -> Uint8List
  Future<Uint8List?> imageCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 94,
      rotate: 90,
    );
    if (result == null) return null;
    print(file.lengthSync());
    print(result.length);
    return result;
  }

  /// 图片压缩 Asset -> Uint8List
  Future<Uint8List?> imageCompressAsset(String assetName) async {
    var list = await FlutterImageCompress.compressAssetImage(
      assetName,
      minHeight: 1920,
      minWidth: 1080,
      quality: 96,
      rotate: 180,
    );
    if (list == null) return null;

    return list;
  }

  /// 图片压缩 Uint8List -> Uint8List
  Future<Uint8List> testComporessList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: 96,
      rotate: 135,
    );
    print(list.length);
    print(result.length);
    return result;
  }

  //生产固定位数的随机数
  static randomBit(int len) {
    String scopeF = '123456789'; //首位
    String scopeC = '0123456789'; //中间
    String result = '';
    for (int i = 0; i < len; i++) {
      if (i == 1) {
        result = scopeF[Random().nextInt(scopeF.length)];
      } else {
        result = result + scopeC[Random().nextInt(scopeC.length)];
      }
    }
    return result;
  }
}
