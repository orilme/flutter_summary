/*
 *  公共的配置文件信息
 */
class CommonConfigEntity {
  CommonConfigEntity({
    this.servicePhone,
    this.coursePic,
    this.courseDesc,
    this.courseUrl,
    this.appBindDeviceUrl,
    this.logoName,
    this.unWorkTimeTip,
    this.computerId,
    this.reportUrl,
    this.aiPlanUrl,
    this.deliverDesignIds,
    this.explosiveProductIds,
    this.singleHouseDesignIds,
    this.messageTemplateMd5,
    this.messageTemplateUrl,
    this.messageTemplateVersion,
    this.findWorkerIndex,
    this.buyFindWorker,
    this.wechatSharingEnable,
    this.wechatAppletSharingEnable,
    this.privacyCallSwitch,
    this.refundDescription,
    this.refundTitle,
    this.unRefundDescription,
    this.unRefundTitle,
    this.commissionRate,
  });

  String get getDeliverDesignIds {
    return deliverDesignIds ?? '';
  }

  String get getExplosiveProductIds {
    return explosiveProductIds ?? '';
  }

  String get getSingleHouseDesignIds {
    return singleHouseDesignIds ?? '';
  }

  CommonConfigEntity.fromJson(Map<String, dynamic> json) {
    servicePhone = json['servicePhone'];
    coursePic = json['coursePic'];
    courseDesc = json['courseDesc'];
    courseUrl = json['courseUrl'];
    appBindDeviceUrl = json['appBindDeviceUrl'];
    logoName = json['logoName'];
    unWorkTimeTip = json['unWorkTimeTip'];
    computerId = json['computerId'];
    reportUrl = json['reportUrl'];
    aiPlanUrl = json['aiPlanUrl'];
    deliverDesignIds = json['deliverDesignIds'];
    explosiveProductIds = json['explosiveProductIds'];
    singleHouseDesignIds = json['singleHouseDesignIds'];
    messageTemplateUrl = json['messageTemplateUrl'];
    messageTemplateVersion = json['messageTemplateVersion'];
    messageTemplateMd5 = json['messageTemplateMd5'];
    findWorkerIndex = json['findWorkerIndex'];
    buyFindWorker = json['buyFindWorker'];
    workerApplyH5JumpUrl = json['WorkerApplyH5JumpUrl'];
    wechatSharingEnable = json['wechatSharingEnable'];
    wechatAppletSharingEnable = json['wechatAppletSharingEnable'];
    privacyCallSwitch = json['privacy_call_switch'];
    refundTitle = json['RefundTitle'];
    unRefundTitle = json['UnRefundTitle'];
    refundDescription = json['RefundDescription'];
    unRefundDescription = json['UnRefundDescription'];
    commissionRate = json['commissionRate'];
  }

  String? servicePhone;
  String? coursePic; //教程 图片
  String? courseDesc; //教程 描述字段
  String? courseUrl; //教程详情页面
  String? appBindDeviceUrl; //绑定设备页面
  String? logoName; //Logo文字，用于切换图片
  String? unWorkTimeTip;
  String? computerId; //声网中主播分享的屏幕uid
  String? reportUrl; //交付报告H5地址
  String? aiPlanUrl; //案例详情H5地址
  String? singleHouseDesignIds; // 单屋设计
  String? deliverDesignIds; // 全案设计
  String? explosiveProductIds; // 大师爆品
  String? messageTemplateVersion; // 消息模板version
  String? messageTemplateUrl; // 消息模板url
  String? messageTemplateMd5; // 消息模板MD5
  String? findWorkerIndex; // 工地直播详情页 -- 深入了解服务
  String? buyFindWorker; // 工地直播详情页 -- 预定施工服务
  String? workerApplyH5JumpUrl; //成为工人H5
  String? wechatSharingEnable; // 是否可以分享到微信, 0:关闭；1.开启
  String? wechatAppletSharingEnable; // 是否可以分享到微信小程序, 0:关闭；1.开启
  String? privacyCallSwitch; // 是否支持隐私通话, 0:关闭；1.开启
  String? refundTitle; // 退款标题
  String? refundDescription; // 退款内容
  String? unRefundTitle; // 不能退款标题
  String? unRefundDescription; // 不能退款内容
  String? commissionRate; // 佣金比例

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['servicePhone'] = this.servicePhone;
    data['coursePic'] = this.coursePic;
    data['courseDesc'] = this.courseDesc;
    data['courseUrl'] = this.courseUrl;
    data['appBindDeviceUrl'] = this.appBindDeviceUrl;
    data['logoName'] = logoName;
    data['unWorkTimeTip'] = unWorkTimeTip;
    data['computerId'] = computerId;
    data['reportUrl'] = reportUrl;
    data['aiPlanUrl'] = aiPlanUrl;
    data['deliverDesignIds'] = deliverDesignIds;
    data['explosiveProductIds'] = explosiveProductIds;
    data['singleHouseDesignIds'] = singleHouseDesignIds;
    data['messageTemplateUrl'] = this.messageTemplateUrl;
    data['messageTemplateVersion'] = this.messageTemplateVersion;
    data['messageTemplateMd5'] = this.messageTemplateMd5;
    data['findWorkerIndex'] = this.findWorkerIndex;
    data['buyFindWorker'] = this.buyFindWorker;
    data['WorkerApplyH5JumpUrl'] = this.workerApplyH5JumpUrl;
    data['wechatSharingEnable'] = this.wechatSharingEnable;
    data['wechatAppletSharingEnable'] = this.wechatAppletSharingEnable;
    data['privacy_call_switch'] = this.privacyCallSwitch;
    data['unRefundDescription'] = this.unRefundDescription;
    data['refundDescription'] = this.refundDescription;
    data['unRefundTitle'] = this.unRefundTitle;
    data['refundTitle'] = this.refundTitle;
    data['commissionRate'] = this.commissionRate;
    return data;
  }
}
