import 'package:flutter/material.dart';

class SliverFillViewportPage extends StatefulWidget {
  const SliverFillViewportPage({Key? key}) : super(key: key);

  @override
  _SliverFillViewportPageState createState() => _SliverFillViewportPageState();
}

class _SliverFillViewportPageState extends State<SliverFillViewportPage> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("SliverFillViewport")),
        backgroundColor: Colors.white,
        body: Center(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillViewport(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                  );
                }, childCount: 4),
                viewportFraction: 1.0,
              )
            ],
          ),
        ),
      ),
    );
  }

}