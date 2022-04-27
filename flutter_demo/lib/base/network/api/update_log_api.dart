import 'riki_base_api.dart';

/// 上传日志Api
class UploadLogApi extends RikiBaseApi {
  UploadLogApi() : super(null);

  Map<String, dynamic> params(String zeusId, String dumpLog) => {'zeusId': zeusId, 'dumpLog': dumpLog};

  @override
  HttpMethod get httpMethod => HttpMethod.post;

  @override
  String apiMethod(params) => 'app/common/open/log';

  @override
  UploadLogApi onExtractResult(resultData, HttpData data) => resultData;
}
