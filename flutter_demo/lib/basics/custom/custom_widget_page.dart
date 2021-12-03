import 'package:flutter/material.dart';
import './custom_checkbox.dart';
import './custom_done_widget.dart';

/// 自定义 RenderObject 的方式来进行UI绘制、动画调度和事件处理。

class CustomWidgetPage extends StatefulWidget {
  @override
  _CustomWidgetPageState createState() => _CustomWidgetPageState();
}

class _CustomWidgetPageState extends State<CustomWidgetPage> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CustomCheckbox'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCheckbox(
              value: _checked,
              onChanged: _onChange,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CustomCheckbox(
                  strokeWidth: 1,
                  radius: 1,
                  value: _checked,
                  onChanged: _onChange,
                ),
              ),
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: CustomCheckbox(
                strokeWidth: 3,
                radius: 3,
                value: _checked,
                onChanged: _onChange,
              ),
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                checkColor: Colors.green,
                focusColor: Colors.purple,
                value: _checked,
                onChanged: _onChange,
              ),
            ),
            CustomDoneWidget(

            )
          ],
        ),
      ),
    );
  }

  void _onChange(value) {
    setState(() => _checked = value);
  }

}

