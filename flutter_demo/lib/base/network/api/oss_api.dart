import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riki_project_config/riki_project_config.dart';
import 'riki_base_api.dart';
import '../entity/upload_file_oss_entity.dart';

/// OSS相关接口
/// 获取OSS相关路径API
class GetOssUrlApi extends RikiBaseApi<UploadFileOssEntity> {
  GetOssUrlApi(BuildContext context) : super(context);

  @override
  HttpMethod get httpMethod => HttpMethod.get;

  @override
  String apiUrl() => '${RikiProjectConfig.server.updateAddress}oss/policy/2?b1594384100075=1';

  @override
  String apiMethod(params) => '';

  @override
  FutureOr<UploadFileOssEntity>? onExtractResult(resultData, HttpData<UploadFileOssEntity> data) {
    return resultData != null ? UploadFileOssEntity.fromJson(resultData) : null;
  }
}
