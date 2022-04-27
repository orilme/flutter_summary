import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final List<Color> colorList = [
  Colors.red,
  Colors.orange,
  Colors.green,
  Colors.purple,
  Colors.blue,
];

class SliverPage extends StatelessWidget {
  Widget renderTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SliverPage"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          this.renderTitle('SliverList/SliverPadding'),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((content, index) {
                return Container(
                  height: 30,
                  color: colorList[index],
                );
              }, childCount: 5),
            ),
          ),
          this.renderTitle('SliverPadding - SliverGrid.count'),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverGrid.count(
              crossAxisCount: 5,
              children: colorList.map((color) => Container(color: color)).toList(),
            ),
          ),
          this.renderTitle('SliverGrid - delegate'),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 5, mainAxisSpacing: 3),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                color: Colors.primaries[index % Colors.primaries.length],
              );
            }, childCount: 10),
          ),

          /// CustomScrollView只能包含sliver系列组件，如果包含普通的组件如何处理？使用SliverToBoxAdapter包裹
          this.renderTitle('SliverToBoxAdapter'),
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              color: Colors.red,
            ),
          ),
          this.renderTitle('SliverLayoutBuilder\n根据组件的约束条件提供子组件，比如当用户向下划动时，盒子显示红色，向上滑动时显示蓝色：'),
          SliverLayoutBuilder(
            builder: (BuildContext context, SliverConstraints constraints) {
              print('${constraints.userScrollDirection}');
              var color = Colors.red;
              if (constraints.userScrollDirection == ScrollDirection.forward) {
                color = Colors.blue;
              }
              return SliverToBoxAdapter(
                  child: Container(
                height: 100,
                color: color,
              ));
            },
          ),
          this.renderTitle('SliverFixedExtentList\n'
              'SliverFixedExtentList是sliver系列组件之一，和SliverList用法一样，\n'
              '唯一的区别就是SliverFixedExtentList是固定子控件的高度的，\n'
              'SliverFixedExtentList比SliverList更加高效，因为SliverFixedExtentList无需计算子控件的布局。'),
          SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(color: colorList[index]),
              childCount: colorList.length,
            ),
            itemExtent: 30,
          ),
          this.renderTitle('SliverPrototypeExtentList\n'
              'SliverPrototypeExtentList和SliverList用法一样，区别是SliverPrototypeExtentList的高度由prototypeItem控件决定。\n'
              'SliverPrototypeExtentList 比SliverList更加高效，因为SliverFixedExtentList无需计算子控件的布局。\n'
              'SliverPrototypeExtentList比SliverFixedExtentList更加灵活，因为SliverPrototypeExtentList不必指定像素高度。'),
          SliverPrototypeExtentList(
            prototypeItem: Text("SliverPrototypeExtentList比SliverFixedExtentList更加灵活，因为SliverPrototypeExtentList不必指定像素高度。",
                style: TextStyle(fontSize: 18, color: Colors.green)),
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                color: colorList[index],
                child: Text("SliverPrototypeExtentList比SliverFixedExtentList更加灵活，因为SliverPrototypeExtentList不必指定像素高度。",
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              childCount: colorList.length,
            ),
            // itemExtent: 50,
          ),
          this.renderTitle('SliverOpacity'),
          SliverOpacity(
            opacity: 0.5,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((content, index) {
                return Container(
                  height: 30,
                  color: colorList[index],
                );
              }, childCount: 5),
            ),
          ),
        ],
      ),
    );
  }
}
