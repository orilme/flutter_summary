import 'package:flutter/material.dart';
import 'package:flutter_demo/base/network/api/riki_base_api.dart';

abstract class BaseApi<D> extends RikiBaseApi<D> {
  BaseApi(BuildContext? context) : super(context);
}
