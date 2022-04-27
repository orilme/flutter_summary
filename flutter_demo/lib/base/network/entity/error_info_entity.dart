/// 错误上报时，要传递给服务器的数据
class ErrorInfoEntity {
  static const String ERROR_TYPE_IM = 'IM';
  static const String ERROR_TYPE_JPUSH = 'JPUSH';

  String? errorType;
  String? errorInfo; //错误信息
  String? code; //错误码
  String? userId; //用户的id
  String? imId; //im的id
  String? jId; //极光的id

  ErrorInfoEntity({
    this.errorType,
    this.errorInfo,
    this.code,
    this.userId,
    this.imId,
  });

  ErrorInfoEntity.fromJson(Map<String, dynamic> json) {
    errorType = json['errorType'];
    errorInfo = json['errorInfo'];
    code = json['code'];
    userId = json['userId'];
    imId = json['imId'];
    jId = json['jId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorType'] = this.errorType;
    data['errorInfo'] = this.errorInfo;
    data['code'] = this.code;
    data['userId'] = this.userId;
    data['imId'] = this.imId;
    data['jId'] = this.jId;
    return data;
  }
}
