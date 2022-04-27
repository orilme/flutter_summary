import 'dart:async';

import 'package:flutter/material.dart';
import '../entity/city_data.dart';
import '../entity/common_config_entity.dart';
import 'package:riki_project_config/riki_project_config.dart';

import 'riki_base_api.dart';

/// 通用API
/// 全局配置配置接口
class CommonConfigApi extends RikiBaseApi<CommonConfigEntity?> {
  CommonConfigApi(BuildContext context) : super(context);

  Map<String, dynamic> params(CommonConfigType type) => {'type': type.value};

  @override
  HttpMethod get httpMethod => HttpMethod.get;

  @override
  String apiMethod(params) => 'app/common/open/config';

  @override
  CommonConfigEntity? onExtractResult(resultData, HttpData<CommonConfigEntity?> data) {
    return resultData != null ? CommonConfigEntity.fromJson(resultData) : null;
  }
}

/// 通用配置参数类型
@immutable
class CommonConfigType {
  const CommonConfigType._(this.value, this.name);

  factory CommonConfigType.byValue(int? value) => value == null
      ? none
      : values.firstWhere(
          (CommonConfigType element) => element.value == value,
          orElse: () => none,
        );

  final int value;
  final String name;

  static const CommonConfigType none = CommonConfigType._(-1, '无'); //未找到
  static const CommonConfigType common = CommonConfigType._(0, '通用配置"');
  static const CommonConfigType app = CommonConfigType._(1, '用户端App相关配置');
  static const CommonConfigType design = CommonConfigType._(2, '中台相关配置');
  static const CommonConfigType web = CommonConfigType._(3, 'Web相关配置');
  static const CommonConfigType appServeRecord = CommonConfigType._(4, 'app服务卡相关配置');
  static const CommonConfigType serveApp = CommonConfigType._(5, '服务端App相关配置');
  static const CommonConfigType skuDesc = CommonConfigType._(6, '相关商品的描述');
  static const CommonConfigType other = CommonConfigType._(20, '其他可用扩展使用');

  static const List<CommonConfigType> values = <CommonConfigType>[none, common, app, design, web, appServeRecord, serveApp, skuDesc, other];

  @override
  String toString() => 'ConfigType($value).$name';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CommonConfigType && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

///省市区api （基于宙斯id）
class ZeusCityApi extends RikiBaseApi<List<CityModel>> {
  ZeusCityApi(BuildContext? context) : super(context);

  @override
  String apiUrl() {
    return RikiProjectConfig.server.updateAddress;
  }

  @override
  HttpMethod get httpMethod => HttpMethod.get;

  @override
  String apiMethod(params) {
    return 'area/list_tree_exclude_qg';
  }

  @override
  FutureOr<List<CityModel>>? onExtractResult(resultData, HttpData<List<CityModel>> data) {
    return resultData == null ? null : resultData.map<CityModel>((e) => CityModel.fromJson(e)).toList();
  }
}
