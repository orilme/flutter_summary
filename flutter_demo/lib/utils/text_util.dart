import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

/// TextUtil.
class TextUtil {
  /// isEmpty
  static bool isEmpty(String? text) {
    return text == null || text.isEmpty;
  }

  /// 每隔 x位 加 pattern
  static String formatDigitPattern(String text, {int digit = 4, String pattern = ' '}) {
    text = text.replaceAllMapped(new RegExp("(.{$digit})"), (Match match) {
      return "${match.group(0)}$pattern";
    });
    if (text.endsWith(pattern)) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  /// 每隔 x位 加 pattern, 从末尾开始
  static String formatDigitPatternEnd(String text, {int digit = 4, String pattern = ' '}) {
    String temp = reverse(text);
    temp = formatDigitPattern(temp, digit: digit, pattern: pattern);
    temp = reverse(temp);
    return temp;
  }

  /// 每隔4位加空格
  static String formatSpace4(String text) {
    return formatDigitPattern(text);
  }

  /// 每隔3三位加逗号
  /// num 数字或数字字符串。int型。
  static String formatComma3(Object num) {
    return formatDigitPatternEnd(num.toString(), digit: 3, pattern: ',');
  }

  /// hideNumber
  static String hideNumber(String phoneNo, {int start = 3, int end = 7, String replacement = '****'}) {
    return phoneNo.replaceRange(start, end, replacement);
  }

  /// replace
  static String replace(String text, Pattern from, String replace) {
    return text.replaceAll(from, replace);
  }

  /// split
  static List<String> split(String text, Pattern pattern) {
    List<String> list = text.split(pattern);
    return list;
  }

  /// reverse
  static String reverse(String text) {
    if (isEmpty(text)) return '';
    StringBuffer sb = StringBuffer();
    for (int i = text.length - 1; i >= 0; i--) {
      sb.writeCharCode(text.codeUnitAt(i));
    }
    return sb.toString();
  }

  static String filterMobile(String text) {
    if (TextUtil.isEmpty(text)) {
      return '';
    }
    if (text.length == 11) {
      return text.substring(0, 3) + ' **** ' + text.substring(7);
    } else {
      return text;
    }
  }

  ///两个字符串比较，返回不是空的那个，如果都为空，直接返回空字符串,都不为空，优先返回firstString。
  static String resultString(String firstString, String lastString) {
    return !TextUtil.isEmpty(firstString) ? firstString : !TextUtil.isEmpty(lastString) ? lastString : '';
  }

  ///把转码后的字符串转成汉字
  static String decodeString(String encodeString) {
    if (TextUtil.isEmpty(encodeString)) {
      return '';
    }
    String decodeStr = encodeString;
    try {
      decodeStr = Uri.decodeComponent(decodeStr);
    } catch (e) {}

    return decodeStr;
  }

  ///随机字符串
  String randomString({int length = 15}) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';

    /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < length; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /// 获取字符串md5值
  static String md5(String str) {
    var content = new Utf8Encoder().convert(str);
    var digest = crypto.md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
