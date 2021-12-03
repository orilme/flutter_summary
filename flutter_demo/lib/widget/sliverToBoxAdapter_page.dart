import 'package:flutter/material.dart';

class SliverToBoxAdapterPage extends StatefulWidget {
  const SliverToBoxAdapterPage({Key? key}) : super(key: key);

  @override
  _SliverToBoxAdapterPageState createState() => _SliverToBoxAdapterPageState();
}

class _SliverToBoxAdapterPageState extends State<SliverToBoxAdapterPage> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("SliverToBoxAdapter")),
        backgroundColor: Colors.white,
        body: Center(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: PageView(
                    children: [Text("1"), Text("2")],
                  ),
                ),
              ),
              // buildSliverFixedList(),
            ],
          ),
        ),
      ),
    );
  }

}