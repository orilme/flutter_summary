import 'package:flutter/services.dart';
import 'package:riki_project_config/riki_project_config.dart';
import 'riki_platform_config.dart';

/// 闪验配置
class SyAppId extends RikiPlatformConfig {
  SyAppId(String android, String ios) : super(android, ios);
}

/// bugly配置
class BuglyAppId extends RikiPlatformConfig {
  BuglyAppId(String android, String ios) : super(android, ios);
}

/// 百度配置
class BaiduLbsApiKey extends RikiPlatformConfig {
  BaiduLbsApiKey(String android, String ios) : super(android, ios);
}

/// app config
class AppConfig {
  static const String _TAG = 'AppConfig';

  // 工厂模式
  factory AppConfig() => _getInstance();

  static AppConfig get instance => _getInstance();
  static AppConfig? _instance;

  static const String _dev = 'dev';
  static const String _stage = 'stage';
  static const String _release = 'release';

  AppConfig._internal() {
    // 根据dart-define 获取环境变量、编译时间
    // 备忘 fromEnvironment必须使用const方式
    _env = const String.fromEnvironment("ENV", defaultValue: _dev);
    if (bool.hasEnvironment('COMPILE_TIME')) {
      compileTime = const int.fromEnvironment("COMPILE_TIME");
    } else {
      compileTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  // 测试使用
  late Map<String, dynamic> _envConfigs;

  List<MapEntry<String, dynamic>> get envConfigs => _envConfigs.entries.toList();

  static AppConfig _getInstance() {
    if (_instance == null) {
      _instance = AppConfig._internal();
    }
    return _instance!;
  }

  void _log(Map msg) {
    if (_env != _release) {
      print('--------------------$_TAG--------------------');
      print('编译时间：${DateTime.fromMillisecondsSinceEpoch(compileTime).toString()}');
      print('-------------------环境配置内容--------------------');
      msg.forEach((key, value) {
        print('$key：$value');
      });
      print('--------------------$_TAG--------------------');
    }
  }

  /// --------------------------------- 固定配置 ---------------------------------------
  /// debug开关，上线需要关闭
  /// App运行在Release环境时，isDebug为false；当App运行在Debug和Profile环境时，isDebug为true
  static const bool is_debug = !const bool.fromEnvironment("dart.vm.product");

  static const int app_type_server = 2; // 服务端

  /// TAG日志标签
  static const String log_tag = 'RIKI_TAG';

  static const int success_code = 1;

  static const String code = 'code';

  static const String message = 'message';

  static const String data = 'data';

  //IM和JPush发送的业务事件messageType 类型上限
  static const int messageTypeLimit = 17;

  static const String user_agent = 'dabanjia';

  /// --------------------------------- 动态配置 ---------------------------------------
  late String _env; // 环境配置

  bool get isDevelopEnv => RikiProjectConfig.envType == RikiEnvType.dev;

  bool get isStageEnv => RikiProjectConfig.envType == RikiEnvType.stage;

  bool get isReleaseEnv => RikiProjectConfig.envType == RikiEnvType.release;

  late int compileTime; // 编译时间
  late String appName; // app名称

  // 渠道名
  final String channel = 'main';

  // 腾讯系 相关参数
  late String tencentSdkAppId; //腾讯im app id
  late String _tencentTrtcAppId; //腾讯trtc app id
  int get tencentTrtcAppId => int.parse(_tencentTrtcAppId);
  late String tencentTrtcSecretKey; //腾讯trtc secret key
  late BuglyAppId _buglyAppId; //bugly app id
  BuglyAppId get buglyAppId => _buglyAppId;
  late String wechatAppId; //微信 app id
  late String wechatUniversalLink; //微信 universal link
  // 推送 相关配置
  late String jpushAppKey; //极光推送 app key
  late String jpushChannel; //极光推送渠道，目前默认了theChannel
  late String hwAppId; //华为 app id
  static const String _XM_PREFIX = 'XM-';
  late String xmAppId; //小米 app id
  late String xmAppKey; //小米 app key
  late String vivoAppId; //vivo app id
  late String vivoAppKey; //vivo app key
  static const String _OPPO_PREFIX = 'OP-';
  late String oppoAppKey;
  late String oppoAppId; //oppo app id
  late String oppoAppSecret; //oppo app secret
  static const String _MZ_PREFIX = 'MZ-';
  late String mzAppId; //魅族 app id
  late String mzAppKey; //魅族 app key

  // 闪验 相关配置
  late SyAppId _syAppId; //闪验 app id
  String get syAppId => _syAppId.value; // 获取对应平台的闪验 app id

  // app store 相关配置
  late String appStoreId; //appStore id

  String get appStoreUrl => 'https://itunes.apple.com/cn/app/id$appStoreId?mt=8'; //appStore跳转网址

  // 声网 相关配置
  late String agoraAppId; //声网 app id

  // 网易 相关配置
  late String netEasyAppKey; // 网易 app key

  // 萤石 相关配置
  late String ezvizAppKey;

  // 百度 相关配置
  late BaiduLbsApiKey _baiduLbsApiKey;

  BaiduLbsApiKey get baiduLbsApiKey => _baiduLbsApiKey;

  RikiEnvType get envType {
    RikiEnvType envType = RikiEnvType.release;
    if (_env == _dev) {
      envType = RikiEnvType.dev;
    } else if (_env == _stage) {
      envType = RikiEnvType.stage;
    } else if (_env == _release) {
      envType = RikiEnvType.release;
    }
    return envType;
  }

  // 阿里云日志参数
  late String pbEndPoint;
  late String pbProject;
  late String pbLogStore;
  late String pbDevLogStore;
  late String pbAccessKeyId;
  late String pbAccessKeySecret;
  //是否开启日志
  late bool pbLogOpen;

  // 获取环境配置文件
  String _getEnvFile() {
    if (_env == _dev) {
      return 'assets/config/.env.dev';
    } else if (_env == _stage) {
      return 'assets/config/.env.stage';
    } else if (_env == _release) {
      return 'assets/config/.env.release';
    }
    return 'assets/config/.env.dev';
  }

  // 初始化环境配置
  Future init() async {
    Map<String, dynamic> configs = {};
    String value = await rootBundle.loadString(_getEnvFile());
    value = value.replaceAll('\r', ''); //解决windows系统换行符问题
    List<String> list = value.split("\n");
    list.forEach((element) {
      if (element.contains("=")) {
        String key = element.substring(0, element.indexOf("="));
        String value = element.substring(element.indexOf("=") + 1);
        configs[key] = value;
      }
    });
    _log(configs);
    _parserConfig(configs);
    return Future.value();
  }

  String _wipeOffPrefix(String value, String prefix) {
    return value.replaceAll(prefix, '');
  }

  void _parserConfig(Map<String, dynamic> configs) {
    configs['COMPILE_TIME'] = DateTime.fromMillisecondsSinceEpoch(compileTime).toString();
    _envConfigs = configs;
    _env = configs['ENV'];

    appName = configs['APP_NAME'];
    tencentSdkAppId = configs['TENCENT_SDK_APP_ID'];
    _tencentTrtcAppId = configs['TENCENT_TRTC_APP_ID'];
    tencentTrtcSecretKey = configs['TENCENT_TRTC_SECRET_KEY'] ?? '';
    wechatAppId = configs['WECHAT_APP_ID'];
    wechatUniversalLink = configs['WECHAT_UNIVERSAL_LINK'];
    jpushAppKey = configs['JPUSH_APPKEY'];
    jpushChannel = configs['JPUSH_CHANNEL'];
    hwAppId = configs['HUAWEI_APPID'];
    xmAppKey = _wipeOffPrefix(configs['XIAOMI_APPKEY'], _XM_PREFIX);
    xmAppId = _wipeOffPrefix(configs['XIAOMI_APPID'], _XM_PREFIX);
    vivoAppKey = configs['VIVO_APPKEY'];
    vivoAppId = configs['VIVO_APPID'];
    oppoAppKey = _wipeOffPrefix(configs['OPPO_APPKEY'], _OPPO_PREFIX);
    oppoAppId = _wipeOffPrefix(configs['OPPO_APPID'], _OPPO_PREFIX);
    oppoAppSecret = _wipeOffPrefix(configs['OPPO_APPSECRET'], _OPPO_PREFIX);
    mzAppKey = _wipeOffPrefix(configs['MEIZU_APPKEY'], _MZ_PREFIX);
    mzAppId = _wipeOffPrefix(configs['MEIZU_APPID'], _MZ_PREFIX);
    _syAppId = SyAppId(configs['SY_APP_ID_ANDROID'], configs['SY_APP_ID_IOS']);
    appStoreId = configs['APP_STORE_ID'];
    agoraAppId = configs['AGORA_APP_ID'];
    netEasyAppKey = configs['NETEASY_APP_KEY'];
    _buglyAppId = BuglyAppId(configs['BUGLY_APP_ID_ANDROID'], configs['BUGLY_APP_ID_IOS']);
    ezvizAppKey = configs['EZVIZ_APP_KEY'];
    _baiduLbsApiKey = BaiduLbsApiKey(configs['BAIDU_LBS_API_KEY_ANDROID'], configs['BAIDU_LBS_API_KEY_IOS']);
    pbEndPoint = configs['PB_ENDPOINT'];
    pbProject = configs['PB_PROJECT'];
    pbLogStore = configs['PB_LOGSTORE'];
    pbDevLogStore = configs['PB_DEV_LOGSTORE'];
    pbAccessKeyId = configs['PB_ACCESS_KEY_ID'];
    pbAccessKeySecret = configs['PB_ACCESS_SECRET'];
    pbLogOpen = configs['PB_PLATFORM_LOG_OPEN'] == 'True' ? true : false;
  }
}

const INDEX_BAR_WORDS = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "#",
];
