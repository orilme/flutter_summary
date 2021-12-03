import 'package:flutter/material.dart';

const double _ITEM_HEIGHT = 70.0;

class ScrollAnimationToItem {
  final String displayName;
  bool selected = false;
  ScrollAnimationToItem(this.displayName, this.selected);
}

class ScrollAnimationToPage extends StatefulWidget {
  ScrollAnimationToPage({Key? key}) : super(key: key);

  @override
  _ScrollAnimationToPageState createState() => new _ScrollAnimationToPageState();
}

class _ScrollAnimationToPageState extends State<ScrollAnimationToPage> {

  late ScrollController _scrollController = new ScrollController();
  late List<ScrollAnimationToItem> _items;

  @override
  void initState() {
    super.initState();

    _items = [];
    _items.add(new ScrollAnimationToItem('詹姆斯', false));
    _items.add(new ScrollAnimationToItem('杜兰特', false));
    _items.add(new ScrollAnimationToItem('库里', false));
    _items.add(new ScrollAnimationToItem('哈登', false));
    _items.add(new ScrollAnimationToItem('威少', false));
    _items.add(new ScrollAnimationToItem('欧文', false));
    _items.add(new ScrollAnimationToItem('戴维斯', false));
    _items.add(new ScrollAnimationToItem('汤神', false));
    _items.add(new ScrollAnimationToItem('格林', false));
    _items.add(new ScrollAnimationToItem('恩比德', false));
    _items.add(new ScrollAnimationToItem('保罗', false));
    _items.add(new ScrollAnimationToItem('乔丹', false));
    _items.add(new ScrollAnimationToItem('莱昂纳德', false));
    _items.add(new ScrollAnimationToItem('塔图姆', false));
    _items.add(new ScrollAnimationToItem('利拉德', false));
    _items.add(new ScrollAnimationToItem('乐福', false));
    _items.add(new ScrollAnimationToItem('科比', false));
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonsWidget = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new FlatButton(
            textColor: Colors.blueGrey,
            color: Colors.white,
            child: new Text('杜兰特'),
            onPressed: _scrollToKd,
          ),
          new FlatButton(
            textColor: Colors.blueGrey,
            color: Colors.white,
            child: new Text('科比'),
            onPressed:_scrollToKobe ,
          ),
        ],
      ),
    );

    Widget itemsWidget = new ListView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        shrinkWrap: true,
        children: _items.map((ScrollAnimationToItem item) {
          return _singleItemDisplay(item);
        }).toList()
    );

    for (int i = 0; i < _items.length; i++) {
      if (_items.elementAt(i).selected) {
        _scrollController.animateTo(i * _ITEM_HEIGHT, duration: new Duration(seconds: 2), curve: Curves.ease);
      }
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("flutter之滚动到列表指定item位置教程"),
      ),
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
        child: new Column(children: <Widget>[
          buttonsWidget,
          new Expanded(
            child:
            itemsWidget,),
        ],
        ),
      ),
    );
  }

  Widget _singleItemDisplay(ScrollAnimationToItem item) {
    return new Container(
      height: _ITEM_HEIGHT,
      child: new Container (
        padding: const EdgeInsets.all(2.0),
        color: new Color(0x33000000),
        child: new Text(item.displayName),
      ),
    );
  }

  void _scrollToKd() {
    setState(() {
      for (var item in _items) {
        if (item.displayName == '杜兰特') {
          item.selected = true;
        } else {
          item.selected = false;
        }
      }
    });
  }

  void _scrollToKobe() {
    setState(() {
      for (var item in _items) {
        if (item.displayName == '科比') {
          item.selected = true;
        } else {
          item.selected = false;
        }
      }
    });
  }

}
