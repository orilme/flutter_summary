import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 缓存工具类
class CacheUtil {
  ///获取缓存文件目录
  static Future<Directory> getCacheDir() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir;
  }

  /// 递归方式 计算文件的大小
  static Future<double> getTotalSizeOfFilesInDir({FileSystemEntity? file}) async {
    try {
      if (file == null) {
        file = await getCacheDir();
      }
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        for (final FileSystemEntity child in children) total += await getTotalSizeOfFilesInDir(file: child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  ///格式化文件大小
  static String renderSize(double value) {
    List<String> unitArr = []..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  ///递归方式删除目录
  static Future<Null> delDir({FileSystemEntity? file}) async {
    try {
      if (file == null) {
        file = await getCacheDir();
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(file: child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}
