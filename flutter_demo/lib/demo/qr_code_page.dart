import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:barcode_scan/barcode_scan.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  late String textStr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("二维码"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,  //居中
        children: [
          Padding(padding: EdgeInsets.all(20), child: Text('二维码展示'),),
          Text("普通二维码"),
          SizedBox(height: 20,),
          QrImage(data: "这是普通二维码",size: 100,),
          Text("中间有图片的二维码"),
          SizedBox(height: 20,),
          QrImage(data: "这是中间有图的二维码", size: 100, embeddedImage: NetworkImage(""
              "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2491682377,1019940373&fm=26&gp=0.jpg"),),
          Padding(padding: EdgeInsets.all(20), child: Text('二维码扫描'),),
          OutlinedButton(
            child: Text("二维码扫描"),
            onPressed: () {
              // _getQrcodeState().then((value) => setState(() {
              //   this.textStr = value;
              // }));
            },
          ),
          SizedBox(height: 20,),
          Text("扫描内容为${this.textStr}"),
        ],
      ),
    );
  }

  // //扫描二维码
  // static Future<String?> _getQrcodeState() async {
  //   try {
  //     const ScanOptions options = ScanOptions(
  //       strings: {
  //         'cancel': '取消',
  //         'flash_on': '开启闪光灯',
  //         'flash_off': '关闭闪光灯',
  //       },
  //     );
  //     final ScanResult result = await BarcodeScanner.scan(options: options);
  //     return result.rawContent;
  //   } catch (e) {
  //
  //   }
  //   return null;
  // }

}
