import 'dart:convert';

import 'package:flutter_demo/base/network/api/update_log_api.dart';
import 'package:flutter_demo/base/network/entity/error_info_entity.dart';

/// 上报异常信息给服务器 工具类
class UploadErrorLogUtil {
  /// 上传异常信息
  /// [errorType] 错误类型
  /// [errorInfo] 错误信息
  /// [code] 错误码
  /// [imId] IM的ID
  /// [jId] 极光的ID
  static Future uploadLog(
    String? errorType,
    String? errorInfo, {
    String? code,
    String? imId,
    String? jId,
  }) {
    UploadLogApi uploadLogApi = UploadLogApi();
    String? zeusId = 'RikiAccount.instance.user?.id?.toString()';
    String? dumpLog = jsonEncode(
      ErrorInfoEntity()
        ..errorType = errorType
        ..errorInfo = errorInfo
        ..userId = 'RikiAccount.instance.user?.tid'
        ..code = code
        ..imId = imId
        ..jId = jId,
    );
    return uploadLogApi.start(params: uploadLogApi.params(zeusId ?? '-1', dumpLog));
  }
}
