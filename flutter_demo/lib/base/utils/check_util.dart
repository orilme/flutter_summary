import 'text_util.dart';

class CheckUtil {
  ///校验手机号
  static bool isPhoneNumber(String content) {
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(content);
    return matched;
  }

  /// 密码正则
  static bool isCheckPassword(String input) {
//    RegExp pwd = RegExp('^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{8,16}');//由大小写字母、数字组成，必须有大小写字母和数字，长度8-16
//    RegExp pwd = RegExp('^(?=.*[A-Z])(?=.*[0-9])[A-Za-z0-9]{8,16}');//由大小写字母、数字组成，必须有大写字母和数字，长度8-16
//    RegExp pwd = RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{8,16}$');//由任意字符组成，必须有大小写字母和数字，长度8-16
    RegExp pwd = RegExp(r'^(?=.*[A-Z])(?=.*[0-9])[A-Za-z0-9]{8,16}$');
    return pwd.hasMatch(input);
  }

  /// 是否包含中文
  static bool isContainsChinese(String input) {
    RegExp exp = RegExp("[\\u4E00-\\u9FA5]+");
    return exp.hasMatch(input);
  }

  /// 判断字符串是否包含字母
  static bool isContainsLetter(String input) {
    RegExp exp = RegExp('.*[a-zA-Z]+.*');
    return exp.hasMatch(input);
  }

  /// 正则：手机号（精确）
  /// <p>移动：134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、178、182、183、184、187、188</p>
  /// <p>联通：130、131、132、145、155、156、171、175、176、185、186</p>
  /// <p>电信：133、153、173、177、180、181、189</p>
  /// <p>新增: 166及199的正则适配</p>
  /// <p>全球星：1349</p>
  /// <p>虚拟运营商：170</p>
  static const String _REGEX_MOBILE_EXACT = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(166)|(17[0,1,3,5-8])|(18[0-9])|(19[8-9]))\\d{8}";

  /// 正则：电话号码
  static const String _REGEX_TEL = "^([0]{1}\\d{2,3}-)|([(]?[（]?([0]{1}\\d{2,3})?[)]?[）]?[-]?)\\d{7,8}";

  /// 正则：邮箱
  static const String _REGEX_EMAIL = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";

  /// 正则：用户名，取值范围为a-z,A-Z,0-9,"_",汉字，不能以"_"结尾,用户名必须是6-20位
  static const String _REGEX_USERNAME = "^[\\w\\u4e00-\\u9fa5]{6,20}(?<!_)";

  /// 密码正则 6-16 位字母加数字组合
  static const String _REGEX_PASSWORD = "^([A-Z]|[a-z]|[0-9]){6,16}";

  ///URL正则
  static bool isUrl(String value) {
    if (TextUtil.isEmpty(value)) {
      return false;
    }
    return RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+").hasMatch(CheckUtil.urlString(value));
  }

  ///拼接url
  static String urlString(String urlString) {
    if (TextUtil.isEmpty(urlString)) {
      return '';
    }
    String _urlString;
    if ((urlString.length > 4) && (urlString.substring(0, 4) == 'www.')) {
      _urlString = 'http://' + urlString;
    } else {
      _urlString = urlString;
    }
    return _urlString;
  }

  /// 正则：QQ号
  static const String _REGEX_TENCENT_QQ = "[1-9][0-9]{4,10}";

  /// 正则：中国邮政编码
  static const String _REGEX_ZIP_CODE = "[0-9]\\d{5}(?!\\d)";

  /// 正则：网址
  static const String _REGEX_HTTP = "[a-zA-z]+://[^\s]*";

  /// 正则：中文真实姓名
  static final String _REGEX_TURENAME = "^[\\u4e00-\\u9fa5]+";
  static final String _REGEX_TURENAME_FEW = "^[\\u4e00-\\u9fa5]+[·•][\\u4e00-\\u9fa5]+"; //少数民族

  /// 正则：标签,长度必须是1-4位
  static const String _REGEX_TAG = "^[\\w\\u4e00-\\u9fa5]{1,4}";

  static bool isMatch({String? regex, String? input}) {
    return input != null && input.length > 0 && RegExp(regex!).hasMatch(input);
  }

  /// 验证是否正确手机号
  static bool isMobile(String phone) {
    return !TextUtil.isEmpty(phone) && phone.length == 11 && CheckUtil.isPhoneNumber(phone);
  }

  /// 验证是否正确网址
  static bool isHttp(String http) {
    return isMatch(regex: _REGEX_HTTP, input: http);
  }

  /// 验证是否正确电话号
  static bool isTel(String tel) {
    return isMatch(regex: _REGEX_TEL, input: tel);
  }

  /// 验证是否正确邮箱
  static bool isEmail(String email) {
    return isMatch(regex: _REGEX_EMAIL, input: email);
  }

  /// 验证是否正确密码
  static bool isPasswrodFormat(String password) {
    return isMatch(regex: _REGEX_PASSWORD, input: password);
  }

  /// 验证是否正确QQ长度
  static bool isQQFormat(String qq) {
    return isMatch(regex: _REGEX_TENCENT_QQ, input: qq);
  }

  /// 验证是否正确邮政编码
  static bool isZipCode(String zipCode) {
    return isMatch(regex: _REGEX_ZIP_CODE, input: zipCode);
  }

  /// 验证是否正确姓名
  static bool isTureName(String name) {
    if (name.contains('·') || name.contains("•")) {
      return isMatch(regex: _REGEX_TURENAME_FEW, input: name);
    }
    return isMatch(regex: _REGEX_TURENAME, input: name);
  }

  /// 验证是否正确标签
  static bool isTag(String tag) {
    return isMatch(regex: _REGEX_TAG, input: tag);
  }

  /// 验证是否正确身份证
  static bool isIdCard(String idCard) {
    String Ai = '';
    //传入不能为空
    if (idCard == null || idCard.trim().isEmpty) {
      return false;
    }
    // 判断号码的长度 15位或18位
    if (idCard.length != 15 && idCard.length != 18) {
      //"身份证号码长度应该为15位或18位。";
      return false;
    }
    // 18位身份证前17位位数字，如果是15位的身份证则所有号码都为数字
    if (idCard.length == 18) {
      Ai = idCard.substring(0, 17);
    } else {
      Ai = idCard.substring(0, 6) + "19" + idCard.substring(6, 15);
    }
    if (!isNumeric(Ai)) {
      //"身份证15位号码都应为数字 ; 18位号码除最后一位外，都应为数字。";
      return false;
    }
    // 判断出生年月是否有效
    String strYear = Ai.substring(6, 10); // 年份
    String strMonth = Ai.substring(10, 12); // 月份
    String strDay = Ai.substring(12, 14); // 日期
    if (!_isDate(strYear + "-" + strMonth + "-" + strDay)) {
      //"身份证出生日期无效。";
      return false;
    }
    DateTime dateTime = DateTime.now();
    DateTime idCardDate = DateTime(int.parse(strYear), int.parse(strMonth), int.parse(strDay));
    int time = idCardDate.millisecond;
    if (dateTime.year - int.parse(strYear) > 150 || dateTime.millisecond - time < 0) {
      //"身份证生日不在有效范围。";
      return false;
    }
    if (int.parse(strMonth) > 12 || int.parse(strMonth) <= 0) {
      //"身份证月份无效";
      return false;
    }
    if (int.parse(strDay) > 31 || int.parse(strDay) <= 0) {
      //"身份证日期无效";
      return false;
    }
    // 判断地区码是否有效
    if (!_getAreaCode().containsKey(Ai.substring(0, 2))) {
      // 如果身份证前两位的地区码不在Map，则地区码有误
      return false;
    }

    return _isVarifyCode(Ai, idCard);
  }

  /// 判断第18位校验码是否正确 第18位校验码的计算方式： 1. 对前17位数字本体码加权求和 公式为：S = Sum(Ai * Wi), i =
  /// 0, ... , 16 其中Ai表示第i个位置上的身份证号码数字值，Wi表示第i位置上的加权因子，其各位对应的值依次为： 7 9 10 5 8 4
  /// 2 1 6 3 7 9 10 5 8 4 2 2. 用11对计算结果取模 Y = mod(S, 11) 3. 根据模的值得到对应的校验码
  /// 对应关系为： Y值： 0 1 2 3 4 5 6 7 8 9 10 校验码： 1 0 X 9 8 7 6 5 4 3 2
  static bool _isVarifyCode(String Ai, String idCard) {
    List<String> varifyCode = ["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"];
    List<String> wi = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"];
    int sum = 0;
    for (int i = 0; i < 17; i++) {
      sum = sum + int.parse(Ai[i]) * int.parse(wi[i]);
    }
    int modValue = sum % 11;
    String strVerifyCode = varifyCode[modValue];
    Ai = Ai + strVerifyCode;
    if (idCard.length == 18) {
      if (Ai != idCard) {
        return false;
      }
    }
    return true;
  }

  /// 将所有地址编码保存在一个Map中
  static Map<String, String> _getAreaCode() {
    Map<String, String> areaCodeMap = Map();
    areaCodeMap["11"] = "北京";
    areaCodeMap["12"] = "天津";
    areaCodeMap["13"] = "河北";
    areaCodeMap["14"] = "山西";
    areaCodeMap["15"] = "内蒙古";
    areaCodeMap["21"] = "辽宁";
    areaCodeMap["22"] = "吉林";
    areaCodeMap["23"] = "黑龙江";
    areaCodeMap["31"] = "上海";
    areaCodeMap["32"] = "江苏";
    areaCodeMap["33"] = "浙江";
    areaCodeMap["34"] = "安徽";
    areaCodeMap["35"] = "福建";
    areaCodeMap["36"] = "江西";
    areaCodeMap["37"] = "山东";
    areaCodeMap["41"] = "河南";
    areaCodeMap["42"] = "湖北";
    areaCodeMap["43"] = "湖南";
    areaCodeMap["44"] = "广东";
    areaCodeMap["45"] = "广西";
    areaCodeMap["46"] = "海南";
    areaCodeMap["50"] = "重庆";
    areaCodeMap["51"] = "四川";
    areaCodeMap["52"] = "贵州";
    areaCodeMap["53"] = "云南";
    areaCodeMap["54"] = "西藏";
    areaCodeMap["61"] = "陕西";
    areaCodeMap["62"] = "甘肃";
    areaCodeMap["63"] = "青海";
    areaCodeMap["64"] = "宁夏";
    areaCodeMap["65"] = "新疆";
    areaCodeMap["71"] = "台湾";
    areaCodeMap["81"] = "香港";
    areaCodeMap["82"] = "澳门";
    areaCodeMap["91"] = "国外";
    return areaCodeMap;
  }

  /// 判断字符串是否为数字,0-9重复0次或者多次
  static bool isNumeric(String num) {
    return isMatch(regex: r"^[0-9]+$", input: num);
  }

  static bool _isDate(String date) {
    return isMatch(
        regex: "^((([0-9]{2})(0[48]|[2468][048]|[13579][26]))" //闰年，能被4整除但不能被100整除
            +
            "|((0[48]|[2468][048]|[13579][26])00)" //闰年，能被400整除
            +
            "-02-29)" //匹配闰年2月29日这一天。如果不是这一天，则由下面式子继续匹配验证。
            +
            "|([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})" //平年（0001-9999）
            +
            "-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))" //月日，1、3、5、7、8、10、12月有31天
            +
            "|((0[469]|11)-(0[1-9]|[12][0-9]|30))" //月日，4、6、9、11月有30天
            +
            "|(02-(0[1-9]|[1][0-9]|2[0-8])))", //平年2月只有28天，月日表示为【02-01至02-28】
        input: date);
  }

  /// URL正则，只用于[UrlText]
  // static const String _REGEX_URL = r"(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Za-z0-9+&@#/%=~_|$?!:,.]*\)|[-A-Za-z0-9+&@#/%=~_|$?!:,.])*";
  static const String _REGEX_URL =
      r"(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Za-z0-9+&@#/%=~_|$?!:,.]*\)|[-A-Za-z0-9+&@#/%=~_|$?!:,.])*(?:\([-A-Za-z0-9+&@#/%=~_|$?!:,.]*\)|[A-Za-z0-9+&@#/%=~_|$])";

  static bool isExactUrl(String value) {
    if (TextUtil.isEmpty(value)) {
      return false;
    }
    String? result = RegExp(_REGEX_URL).stringMatch(value);
    return value == result;
  }

  /// 是否包含中文符号
  static bool isContainsDoubleChars(String input) {
    RegExp exp = RegExp('[\u3002\uff1b\uff0c\uff1a\u201c\u201d\uff08\uff09\u3001\uff1f\u300a\u300b]');
    return exp.hasMatch(input);
  }
}
