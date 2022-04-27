import 'dart:convert';

/// 备注：城市实体，基于宙斯id

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class Root {
  Root({
    this.code,
    this.message,
    this.data,
    this.traceId,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) {
    final List<CityModel>? data = jsonRes['data'] is List ? <CityModel>[] : null;
    if (data != null) {
      for (final dynamic item in jsonRes['data']!) {
        if (item != null) {
          data.add(CityModel.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Root(
      code: asT<int?>(jsonRes['code']),
      message: asT<String?>(jsonRes['message']),
      data: data,
      traceId: asT<Object?>(jsonRes['traceId']),
    );
  }

  int? code;
  String? message;
  List<CityModel>? data;
  Object? traceId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'message': message,
        'data': data,
        'traceId': traceId,
      };
}

class CityModel {
  CityModel({
    this.id,
    this.name,
    this.parentId,
    this.sort,
    this.adCode,
    this.children,
  });

  factory CityModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<CityModel>? children = jsonRes['children'] is List ? <CityModel>[] : null;
    if (children != null) {
      for (final dynamic item in jsonRes['children']!) {
        if (item != null) {
          children.add(CityModel.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return CityModel(
      id: asT<int?>(jsonRes['id']),
      name: asT<String?>(jsonRes['name']),
      parentId: asT<int?>(jsonRes['parentId']),
      sort: asT<Object?>(jsonRes['sort']),
      adCode: asT<String?>(jsonRes['adCode']),
      children: children,
    );
  }

  int? id;
  String? name;
  int? parentId;
  Object? sort;
  String? adCode;
  List<CityModel>? children;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'parentId': parentId,
        'sort': sort,
        'adCode': adCode,
        'children': children,
      };
}
