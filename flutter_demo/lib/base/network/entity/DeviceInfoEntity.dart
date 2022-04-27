/// 设备信息实体类

class DeviceInfoEntity {
  /*
{
  "osType": "android",
  "appVersion": "1.0.0",
  "deviceName": "TAS-AL00",
  "deviceId": "89803ffe0a9459c712448a3ae2e94f06",
  "netType": "wifi",
  "supported32BitAbis": "",
  "supported64BitAbis": "",
  "supportedAbis": "",
  "screenRatio": "753.0*360.0"
}
*/

  String? osType; //android or ios
  String? appVersion; //当前手机的version
  String? deviceName; //设备名字
  String? netType; //网络环境  wifi  flow
  String? supported32BitAbis; //所支持的32架构（android使用）
  String? supported64BitAbis; //所支持的64位价格（android使用）
  String? supportedAbis; //支持的所有架构（android使用）
  String? screenRatio; //屏幕分辨率
  String? systemVersion; //手机系统版本

  DeviceInfoEntity({
    this.osType,
    this.appVersion,
    this.deviceName,
    this.netType,
    this.supported32BitAbis,
    this.supported64BitAbis,
    this.supportedAbis,
    this.screenRatio,
    this.systemVersion,
  });

  DeviceInfoEntity.fromJson(Map<String, dynamic> json) {
    osType = json["osType"]?.toString();
    appVersion = json["appVersion"]?.toString();
    deviceName = json["deviceName"]?.toString();
    netType = json["netType"]?.toString();
    supported32BitAbis = json["supported32BitAbis"]?.toString();
    supported64BitAbis = json["supported64BitAbis"]?.toString();
    supportedAbis = json["supportedAbis"]?.toString();
    screenRatio = json["screenRatio"]?.toString();
    systemVersion = json['systemVersion']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["osType"] = osType;
    data["appVersion"] = appVersion;
    data["deviceName"] = deviceName;
    data["netType"] = netType;
    data["supported32BitAbis"] = supported32BitAbis;
    data["supported64BitAbis"] = supported64BitAbis;
    data["supportedAbis"] = supportedAbis;
    data["screenRatio"] = screenRatio;
    data['systemVersion'] = systemVersion;
    return data;
  }
}
