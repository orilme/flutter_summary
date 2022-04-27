import 'dart:convert';
import 'dart:typed_data';
import 'package:lpinyin/lpinyin.dart';
import 'package:intl/intl.dart' as intl;

extension StringExtension on String {
  // 中文2字符，英文1字符长度
  int get specialLength {
    final RegExp regexp = RegExp("[\u4e00-\u9fa5]");

    final List<RegExpMatch> r = regexp.allMatches(this).toList();
    final List<int> chinese = r.map((RegExpMatch e) => e.start).toList();
    int currentLength = 0;
    for (int i = 0; i < length; i++) {
      if (chinese.contains(i)) {
        currentLength += 2;
      } else {
        currentLength += 1;
      }
    }
    return currentLength;
  }

  /// Base64加密
  String encodeBase64() {
    final List<int> content = utf8.encode(this);
    final String digest = base64Encode(content);
    return digest;
  }

  /// Base64解密
  String decodeBase64() {
    return String.fromCharCodes(base64Decode(this));
  }

  /// 字符串转时间
  ///
  /// [format] 格式
  /// [locale] 语言
  DateTime getDateTime({String format = 'yyyy-MM-dd HH:mm:ss', String? locale = 'zh'}) {
    if (this == '') {
      return DateTime.now();
    }
    final intl.DateFormat dateFormat = intl.DateFormat(format, locale);
    return dateFormat.parse(this);
  }

  /// 图片base64转Uint8List
  Uint8List get uint8List {
    if (this == '' || !contains(',')) {
      return Uint8List.fromList(<int>[]);
    }
    final List<String> list = split(',');
    String tempString = '';
    if (list.length == 2) {
      tempString = list[1];
    }
    return base64.decode(tempString);
  }

  /// 将每个字符串之间插入零宽空格
  String get showContent {
    if (isEmpty) {
      return this;
    }
    String breakWord = '';
    runes.forEach((int element) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    });
    return breakWord;
  }

  /// 获取拼音首字母
  String getPinyinE({String placeholder = '#'}) {
    final String pinyin = PinyinHelper.getPinyinE(this);
    final String tag = pinyin.substring(0, 1).toUpperCase();
    if (RegExp("[A-Z]").hasMatch(tag)) {
      return tag;
    } else {
      return placeholder;
    }
  }
}
