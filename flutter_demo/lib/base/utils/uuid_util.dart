import 'package:uuid/uuid.dart';

/// 创建时间：2020/12/07
/// 作者：张健夫
/// 描述：获取唯一标识 uuid

class UuidUtil {
  // 工厂模式
  factory UuidUtil() => _getUuid();

  static UuidUtil get instance => _getUuid();
  static UuidUtil? _instance;

  UuidUtil._internal();

  static UuidUtil _getUuid() {
    if (_instance == null) {
      _instance = new UuidUtil._internal();
    }
    return _instance!;
  }

  ///获取uuid
  String getUUid() {
    Uuid uuid = Uuid();
    return uuid.v1();
  }
}
