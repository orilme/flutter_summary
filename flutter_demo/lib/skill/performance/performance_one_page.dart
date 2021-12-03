
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app/page_view/data_sets.dart';


var lines = [
  "File drop",
  "Install APK",
  "To install an APK, drag & drop an APK file (ending with .apk) to the scrcpy window.",
  "There is no visual feedback, a log is printed to the console.",
  "Push file to device",
  "To push a file to /sdcard/ on the device, drag & drop a (non-APK) file to the scrcpy window.",
  "There is no visual feedback, a log is printed to the console.",
  "The target directory can be changed on start:",
  "scrcpy --push-target=/sdcard/Download/",
  "Audio forwarding",
  "Audio is not forwarded by scrcpy. Use sndcpy.",
];

class PerformanceOnePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent,
      child: Center(
        child: ListView(
          children: [
            for(var i=0;i<100000;i++) _buildItemWidget(i),
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget(int i) {
    var line = lines[i % lines.length];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 18),
      child: Row(
        children: [
          Container(
            color: Colors.black,
            child: SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: Text(
                  line.substring(0,1),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(child: Text(
            line,
            softWrap: false,
          ))
        ],
      ),
    );
  }
}
