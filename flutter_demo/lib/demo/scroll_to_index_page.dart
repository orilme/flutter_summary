import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ScrollToIndexPage extends StatefulWidget {
  @override
  _ScrollToIndexPageState createState() => _ScrollToIndexPageState();
}

class _ScrollToIndexPageState extends State<ScrollToIndexPage> {

  static const maxCount = 100;

  late AutoScrollController controller;

  late List<List<int>> randomList;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical
    );

    /// 一个 index 和 item 高度的数组
    randomList = List.generate(maxCount,
            (index) => <int>[index, (1000 * math.Random().nextDouble()).toInt()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("ScrollToIndexPage"),
      ),
      body: new Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          controller: controller,
          children: randomList.map<Widget>((data) {
            return Padding(
              padding: EdgeInsets.all(8),
              child: _getRow(data[0], math.max(data[1].toDouble(), 50.0)),
            );
          }).toList(),
        ),
      ),
      persistentFooterButtons: <Widget>[
        new FlatButton(
          onPressed: () async {
            /// 滑动到第13个的位置
            await controller.scrollToIndex(13, preferPosition: AutoScrollPosition.begin);
            controller.highlight(13);
          },
          child: new Text("Scroll to 13"),
        ),
      ],
    );
  }

  Widget _getRow(int index, double height) {
    return _wrapScrollTag(
        index: index,
        child: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.topCenter,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue, width: 4),
              borderRadius: BorderRadius.circular(12)),
          child: Text('index: $index, height: $height'),
        )
    );
  }

  Widget _wrapScrollTag({int index = 0, Widget? child}) => AutoScrollTag(
    key: ValueKey(index),
    controller: controller,
    index: index,
    child: child,
    highlightColor: Colors.black.withOpacity(0.1),
  );

}