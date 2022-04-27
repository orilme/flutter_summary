import 'package:url_launcher/url_launcher.dart';

class RikiCallPhone {
  /// 拨打电话
  static void callPhone(String phone) async {
    String phoneUrl = 'tel:$phone';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }
}
