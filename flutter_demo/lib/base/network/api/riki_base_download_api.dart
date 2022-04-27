import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/base/utils/log_util.dart';
import 'package:flutter_demo/base/utils/text_util.dart';
import 'package:flutter_demo/base/network/api/index.dart';
import 'package:riki_http/riki_http.dart';

export 'package:riki_http/riki_http.dart';
export 'api_test.dart';

abstract class RikiBaseDownloadApi extends SimpleDownloadApi {
  final BuildContext context;

  RikiBaseDownloadApi(this.context);

  /// 是否需要AccessToken
  bool isAccessToken() => true;

  /// accessToken类型
  RikiAccessTokenType accessTokenType() => RikiAccessTokenType.none;

  /// accessToken
  String? accessToken() => 'token';

  /// 接口base地址
  @protected
  String downloadUrl(params);

  @protected
  FutureOr<String> onDownloadPath(dynamic params);

  /// 接口全路径
  @override
  String onUrl(dynamic params) {
    String allUrl = downloadUrl(params);
    if (accessTokenType() == RikiAccessTokenType.url && !TextUtil.isEmpty(accessToken())) {
      if (allUrl.contains('?')) {
        allUrl += '&accessToken=${accessToken()}';
      } else {
        allUrl += '?accessToken=${accessToken()}';
      }
    }
    return allUrl;
  }

  /// 接口请求方式——download
  @override
  HttpMethod get httpMethod => HttpMethod.download;

  @override
  Map<String, dynamic> onHeaders(dynamic params) {
    Map<String, dynamic> data = Map();
    String accessTokenStr = accessToken() ?? '';
    if (isAccessToken() && !TextUtil.isEmpty(accessTokenStr)) {
      data['accessToken'] = accessTokenStr;
    }
    return data;
  }

  @override
  HttpData<void> onCreateApiData() => HttpData<void>();

  /// 接口传参统一化处理
  /// params为传入参数
  /// data为接口最后参数
  @override
  void onFillParams(Map<String, dynamic> data, Map<String, dynamic> params) => data.addAll(params);

  /// 返回的Response的code码
  @override
  onResponseCode(response) => null;

  /// 无网络信息
  @override
  String onNetworkError(HttpData data) {
    // 其他服务提示
    try {
      if (data.response == null) throw Exception();
      dynamic error = data.response!.dioError;
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

  /// 网络异常信息
  @override
  String onNetworkRequestFailed(HttpData data) {
    try {
      if (data.response == null) throw Exception();
      return data.response!.dioError.toString();
    } catch (e1) {
      return _onApiErrorMessage(null, data, '网络开小差咯.请稍后重试.')!;
    }
  }

  String? _onApiErrorMessage(response, HttpData data, String defaultMsg) {
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
}
