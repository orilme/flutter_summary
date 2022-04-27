import 'package:flutter/cupertino.dart';

/// 作者：李佳奇
/// 日期：2021/12/17
/// 备注：伪堆，临时、短暂的存储一些变量。

_FakeDump fakeDump = _FakeDump();

class _FakeDump{

  final List<FakeStruct> _dump = [];

  ///根据id获取对象
  FakeStruct? fetchById(int id) {
    FakeStruct? target;
    try{
      target = _dump.singleWhere((element) => element.id == id);
    } catch (e) {
      debugPrint(e.toString());
    }
    clearInvalid();
    return target;
  }

  ///获取最后一个对象
  FakeStruct? popObject() {
    if(_dump.isEmpty) return null;

    final FakeStruct object = _dump.removeLast();
    return object;
  }

  ///插入一个对象
  void insertObject(FakeStruct struct) {
    _dump.add(struct);
  }

  ///清楚所有失效的对象
  void clearInvalid() {
    _dump.removeWhere((element) => !element._isValid);
  }

}

///变量结构体
/// * 一次性取用
class FakeStruct{

  FakeStruct(this.id, this._object);

  ///唯一标识
  /// * 可以使用时间戳
  final int id;

  final dynamic _object;

  bool _isValid = true;

  bool get isValid => _isValid;

  dynamic getObject() {
    _isValid = false;
    return _object;
  }

}















