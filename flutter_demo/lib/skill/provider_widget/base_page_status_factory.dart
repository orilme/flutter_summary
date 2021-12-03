import 'package:flutter/cupertino.dart';

/// 此类配合[ProviderWidget]为页面提供各种状态[Widget]
/// * 继承此类，实现此类方法并作为参数传入[ProviderWidget]便可实现自定义页面状态
/// * 或者使用同路径下 /default 文件夹下的默认类

abstract class BasePageStatusFactory {
  /// 页面[ViewState.empty]状态
  Widget fetchEmptyStatusWidget();

  /// 页面[ViewState.error]状态
  Widget fetchErrorStatusWidget();

  /// 网络异常状态[ViewState.noNet]
  Widget fetchNetExceptionStatusWidget();

  /// 页面[ViewState.busy]状态
  Widget fetchBusyStatusWidget();
}
