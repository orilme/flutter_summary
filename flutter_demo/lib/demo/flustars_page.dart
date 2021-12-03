import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';

/*
// 如果设计稿尺寸默认配置一致，无需该设置。  配置设计稿尺寸 默认 360.0 / 640.0 / 3.0
// setDesignWHD(_designW,_designH,_designD);

// 不依赖context
// 屏幕宽
double screenWidth = ScreenUtil.getInstance().screenWidth;
// 根据屏幕宽适配后尺寸
double adapterW100 = ScreenUtil.getInstance().getWidth(100);

// 依赖context
// 屏幕宽
double screenWidth = ScreenUtil.getScreenW(context);
// 根据屏幕宽适配后尺寸
double adapterW100 = ScreenUtil.getScaleW(context, 100);
 */

class FlustarsPage extends StatefulWidget {
  @override
  _FlustarsPageState createState() => _FlustarsPageState();
}

class _FlustarsPageState extends State<FlustarsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Flustars"),
      ),
      body: Container(
        color: Colors.red,
        width: ScreenUtil().screenWidth - 30, //ScreenUtil.getInstance().screenWidth - 30,
        height: ScreenUtil.getInstance().screenHeight - 300,
        child: Text('哈哈哈'),
      ),
    );
  }

}