import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riki_project_config/riki_project_config.dart';

import 'package:flutter_demo/base/utils/log_util.dart';
import 'package:flutter_demo/base/utils/text_util.dart';

import 'package:riki_http/riki_http.dart';
import 'api_test.dart';

export 'package:riki_http/riki_http.dart';
export 'api_test.dart';

const String RESPONSE_SUCCESS = '1';

/// AccessToken拼接方式
enum RikiAccessTokenType {
  none, // 不拼接
  header, // 在header中添加
  url, // 拼接在url中
}

abstract class RikiBaseApi<D> extends SimpleApi<D> {
  final BuildContext? context;

  RikiBaseApi(this.context);

  /// 是否需要AccessToken
  bool isAccessToken() => true;

  /// accessToken类型
  RikiAccessTokenType accessTokenType() => RikiAccessTokenType.none;

  /// accessToken
  String? accessToken() => 'token';

  //返回实体的key
  @override
  String responseResult() => 'data';

  /// 接口base地址
  @protected
  String apiUrl() => RikiProjectConfig.server.apiUrl;

  /// 接口全路径
  @override
  String onUrl(dynamic params) {
    String allUrl = apiUrl() + apiMethod(params);
    if (accessTokenType() == RikiAccessTokenType.url && !TextUtil.isEmpty(accessToken())) {
      if (allUrl.contains('?')) {
        allUrl += '&accessToken=${accessToken()}';
      } else {
        allUrl += '?accessToken=${accessToken()}';
      }
    }
    return allUrl;
  }

  /// 填写接口方法
  String apiMethod(dynamic params);

  /// 接口传参统一化处理
  /// params为传入参数
  /// data为接口最后参数
  @override
  void onFillParams(Map<String, dynamic> data, Map<String, dynamic> params) => data.addAll(params);

  /// 返回的Response的code码
  @override
  onResponseCode(response) {
    if (response is String) {
      response = jsonDecode(response);
    }
    return response['code'];
  }

  /// 接口正确的状态码判断
  @override
  bool onResponseResult(response) {
    if (response is String) {
      response = jsonDecode(response);
    }
    String codeStr = onResponseCode(response).toString();
    return codeStr == RESPONSE_SUCCESS;
  }

  @override
  FutureOr<D>? onRequestFailed(response, HttpData<D> data) {
    if (response is String) {
      response = jsonDecode(response);
    }
    // 获取到response的code码
    String code = onResponseCode(response).toString();
    // TODO 根据code码，做不同的处理
    return super.onRequestFailed(response, data);
  }

  /// 接口错误信息返回
  @override
  String onRequestFailedMessage(response, HttpData<D> data) {
    if (response is String) {
      response = jsonDecode(response);
    }
    // 获取到response的code码
    String code = onResponseCode(response).toString();
    // TODO 根据code码，设置不同的提示语
    return _onApiErrorMessage(response, data, response['message'] ?? response.toString())!;
  }

  /// 接口正确信息返回
  @override
  String onRequestSuccessMessage(response, HttpData<D> data) {
    if (response is String) {
      response = jsonDecode(response);
    }
    return response['message'];
  }

  /// 接口参数错误信息
  @override
  String onParamsError(dynamic params) => '接口参数错误';

  /// 接口解析异常信息
  @override
  String onParseFailed(HttpData<D> data) => '数据解析失败';

  /// 无网络信息
  @override
  String onNetworkError(HttpData<D> data) {
    // 其他服务提示
    try {
      dynamic? error = data.response?.dioError;
      if (error != null) {
        if (error is SocketException) {
          return '网络异常.请检查你的网络.';
        } else if (error is HttpException) {
          return '服务器异常.请稍后重试.';
        } else if (error is FormatException) {
          return '数据解析错误.';
        } else if (error is TimeoutException) {
          return '连接超时.请稍后重试.';
        } else {
          return _onApiErrorMessage(null, data, '网络开小差咯.请稍后重试.')!;
        }
      } else {
        return _onApiErrorMessage(null, data, '网络开小差咯.请稍后重试.')!;
      }
      // if (data.response.dioError != null) {
      //   return data.response.dioError.toString();
      // } else {
      //   return _onApiErrorMessage(null, data, '网络开小差咯.请稍后重试.');
      // }
    } catch (e) {
      return _onApiErrorMessage(null, data, '网络开小差咯.请稍后重试.')!;
    }
  }

  @override
  FutureOr<String> onCatchMessage(HttpData<D> data, dynamic e) => e.toString();

  /// 网络异常信息
  @override
  String onNetworkRequestFailed(HttpData<D> data) {
    if (data.httpCode == 401) {
      // TODO Token过期处理
      return '';
    }
    // 服务器4xx  5xx显示提示
    try {
      if (data.response == null) throw Exception();
      return onRequestFailedMessage(jsonDecode(data.response!.data), data);
    } catch (e) {
      try {
        if (data.response == null) throw Exception();
        return data.response!.dioError.toString();
      } catch (e1) {
        return _onApiErrorMessage(null, data, '网络开小差咯.请稍后重试.')!;
      }
    }
  }

  String? _onApiErrorMessage(response, HttpData<D> data, String defaultMsg) {
    String? errorMsg = defaultMsg;
    if (response == null) {
      switch (data.response?.errorType) {
        case HttpErrorType.connectTimeout:
          errorMsg = '连接超时.请稍后重试.';
          break;
        case HttpErrorType.sendTimeout:
          errorMsg = '连接超时.请稍后重试.';
          break;
        case HttpErrorType.receiveTimeout:
          errorMsg = '连接超时.请稍后重试.';
          break;
        case HttpErrorType.response:
          if (data.httpCode == 400) {
            errorMsg = '请求错误.请稍后重试.';
          } else if (data.httpCode == 401) {
            errorMsg = '身份授权失败.请稍后重试.';
          } else if (data.httpCode == 403) {
            errorMsg = '禁止访问.请稍后重试.';
          } else if (data.httpCode == 404) {
            errorMsg = '您访问的页面丢失.请稍后重试.';
          } else if (data.httpCode == 405) {
            errorMsg = '您的操作被禁止.请稍后重试.';
          } else if (data.httpCode == 406) {
            errorMsg = '网络开小差咯.请稍后重试.';
          } else if (data.httpCode == 407) {
            errorMsg = '代理授权失败.请稍后重试.';
          } else if (data.httpCode == 408) {
            errorMsg = '您的请求已超时.请稍后重试.';
          } else if (data.httpCode == 409) {
            errorMsg = '服务器异常.请稍后重试.';
          } else if (data.httpCode == 410) {
            errorMsg = '您访问的是无效资源.';
          } else if (data.httpCode == 500) {
            errorMsg = '服务器处理异常.请稍后重试.';
          } else if (data.httpCode == 501) {
            errorMsg = '服务器请求异常.请稍后重试.';
          } else if (data.httpCode == 502) {
            errorMsg = '无效的服务器请求.请稍后重试.';
          } else if (data.httpCode == 503) {
            errorMsg = '服务器暂无响应.请耐心等待.';
          } else if (data.httpCode == 504) {
            errorMsg = '服务器响应超时.请耐心等待.';
          } else if (data.httpCode == 505) {
            errorMsg = '服务器处理异常.Err.505';
          } else if (data.httpCode >= 411 && data.httpCode <= 417) {
            errorMsg = '系统异常.Err.' + data.httpCode.toString();
          }
          break;
        case HttpErrorType.cancel:
          break;
        default:
          break;
      }
    } else {
      String code = onResponseCode(response).toString();
      if (data.response?.data != null) {
        dynamic body = data.response!.data;
        if (body is String) {
          try {
            body = jsonDecode(body);
            if (body != null && body.containsKey('message')) {
              errorMsg = body['message'];
            }
          } catch (e) {
            LogUtil.v('纯字符串body');
          }
        }
      } else {
        errorMsg = '网络连接异常.请稍后重试—Err.' + code;
      }
    }
    return errorMsg;
  }

  /// 接口请求方式 默认post
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  @override
  Map<String, dynamic> onHeaders(dynamic params) {
    Map<String, dynamic> data = Map();
    String accessTokenStr = accessToken() ?? '';
    if (isAccessToken() && !TextUtil.isEmpty(accessTokenStr)) {
      data['accessToken'] = accessTokenStr;
    }
    return data;
  }

//  /// 接口解析方式  默认json
//  @override
//  void onConfigOptions(Options options, dynamic params) {
//    options.contentType = 'application/json;charset=UTF-8';
//    options.connectTimeout = 30000; //配置超时时间
//    options.readTimeout = 30000; //配置读取时间
//    options.sendTimeout = 30000; //配置发送时间
//  }

  /// 测试数据
  dynamic testResultData(dynamic params) {
    return null;
  }

  /// 测试方法
  Future<ApiTestEntity<D>> test({
    dynamic params,
    int retry = 0,
    OnProgress? onProgress,
  }) {
    return ApiTest.start<D>(onExtractResult(testResultData(params), HttpData<D>()) as D, params: params);
  }
}
