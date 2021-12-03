import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/*
GridTile 源码分析：
 @override
  Widget build(BuildContext context) {
    if (header == null && footer == null)
      return child;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: child,
        ),
        if (header != null)
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: header,
          ),
        if (footer != null)
          Positioned(
            left: 0.0,
            bottom: 0.0,
            right: 0.0,
            child: footer,
          ),
      ],
    );
  }
 */

class StaggeredGridViewPage extends StatefulWidget {
  const StaggeredGridViewPage({Key? key}) : super(key: key);

  @override
  _StaggeredGridViewPageState createState() => _StaggeredGridViewPageState();
}

class _StaggeredGridViewPageState extends State<StaggeredGridViewPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("StaggeredGridView")),
        backgroundColor: Colors.black12,
        body: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: 20,
            itemBuilder: (context, index) {
              return GridTile(
                header: GridTileBar(
                  title: Text('标题'),
                  subtitle: Text('我是 subtitle'),
                  backgroundColor: Colors.blue,
                  leading: Icon(Icons.favorite),
                  trailing: Icon(Icons.sailing),
                ),
                child: Container(
                  color: Colors.green,
                ),
                footer: GridTileBar(title: Text('Footer'),),
              );
            },
            staggeredTileBuilder: (index) =>
                StaggeredTile.count(2, index == 0 ? 2.5 : 2)
        ),
      ),
    );
  }
}
