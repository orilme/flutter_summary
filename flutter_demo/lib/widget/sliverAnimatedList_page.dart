import 'package:flutter/material.dart';

class SliverAnimatedListPage extends StatefulWidget {
  @override
  _SliverAnimatedListPageState createState() => _SliverAnimatedListPageState();
}

class _SliverAnimatedListPageState extends State<SliverAnimatedListPage> {
  List<int> _list = [];
  var _key = GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // SliverAnimatedList.of(context);
                final int _index = _list.length;
                _list.insert(_index, _index);
                _key.currentState?.insertItem(_index);
              },
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                final int _index = _list.length - 1;
                var item = _list[_index].toString();
                _key.currentState?.removeItem(_index,
                        (context, animation) => _buildItem(item, animation));
                _list.removeAt(_index);
              },
            ),
          ],
        ),
        SliverAnimatedList(
          key: _key,
          initialItemCount: _list.length,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) {
            return _buildItem(_list[index].toString(), animation);
          },
        ),
      ],
    );
  }

  /// 动画1
  Widget _buildItem(String _item, Animation<double> _animation) {
    return SizeTransition(
      sizeFactor: _animation,
      child: Card(
        child: ListTile(
          title: Text(
            _item,
          ),
        ),
      ),
    );
  }

  /// 动画2
  // Widget _buildItem(String _item, Animation _animation) {
  //   return SlideTransition(
  //     position: _animation
  //         .drive(CurveTween(curve: Curves.easeIn))
  //         .drive(Tween<Offset>(begin: Offset(1, 1), end: Offset(0, 1))),
  //     child: Card(
  //       child: ListTile(
  //         title: Text(
  //           _item,
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
