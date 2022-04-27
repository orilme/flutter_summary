class LogUtil {
  static const String _TAG_DEF = "###LOG_TAG###";

  /// 每次打印的最大长度
  static const _logBufferSize = 1000;

  static bool _debuggable = false; //是否是debug模式,true: log v 不输出.
  static String _TAG = _TAG_DEF;

  static void init({bool isDebug = false, String tag = _TAG_DEF}) {
    _debuggable = isDebug;
    _TAG = tag;
  }

  static void e(Object object, {String? tag}) {
    _printLog(tag, '  e  ', object);
  }

  static void v(Object object, {String? tag}) {
    if (_debuggable) {
      _printLog(tag, '  v  ', object);
    }
  }

  static void _printLog(String? tag, String stag, Object object) {
    String da = object.toString();
    String _tag = (tag == null || tag.isEmpty) ? _TAG : tag;
    final finalMessage = "$_tag $stag $da";

    if (finalMessage.length <= _logBufferSize) {
      print(finalMessage);
    } else {
      for (var it in _wrap(finalMessage)) {
        print(it);
      }
    }
  }

  /// 按换行父切割字符串为若干组
  ///
  /// [src] 原字符串
  static Iterable<String> _wrap(String src) sync* {
    final buffer = StringBuffer();

    for (var line in src.split('\n')) {
      for (var part in _chunked(line)) {
        if (buffer.length + part.length > _logBufferSize) {
          yield buffer.toString();
          buffer.clear();
        }

        buffer..write(part)..write('\n');
      }
    }

    if (buffer.length > 0) {
      yield buffer.toString();
    }
  }

  /// 按照指定大小将字符串截取成一组子字符串
  ///
  /// [src] 原字符串
  static Iterable<String> _chunked(String src) sync* {
    final length = src.length;

    var index = 0;
    while (index < length) {
      final end = index + _logBufferSize;
      final coercedEnd = end > length ? length : end;
      yield src.substring(index, coercedEnd);

      index = coercedEnd;
    }
  }
}
