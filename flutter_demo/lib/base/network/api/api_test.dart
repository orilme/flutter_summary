import 'dart:math';

enum ApiTestType {
  success,
  failed,
  empty,
}

class ApiTestEntity<T> {
  bool? success;
  T? result;
  dynamic params;

  ApiTestEntity<T> setValue(ApiTestType type, T result, {dynamic params}) {
    if (type == ApiTestType.failed) {
      success = false;
      this.result = null;
    } else {
      success = true;
      this.result = result;
    }
    this.params = params;
    return this;
  }
}

class ApiTest {
  static Future<ApiTestType> wait() async {
    await Future.delayed(Duration(seconds: 1));
    int num = Random().nextInt(100);
    ApiTestType type = ApiTestType.success;
    if (num > 80) {
      type = ApiTestType.failed;
    } else if (num < 20) {
      type = ApiTestType.empty;
    }
    return type;
  }

  static Future<ApiTestEntity<T>> start<T>(T result, {dynamic params}) async {
    ApiTestType type = await wait();
    return ApiTestEntity<T>().setValue(type, result, params: params);
  }
}
