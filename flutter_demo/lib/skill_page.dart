import 'package:flutter/material.dart';
import 'package:flutter_demo/index.dart';

class SkillPage extends StatefulWidget {
  @override
  _SkillPageState createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {

  final Map<String, Widget> pageMap = {
    'ProviderWidget': ProviderWidgetPage(),
    'Key 作用': KeyStudyPage(),
    'GlobalKey 使用': GlobalKeyPage(),
    'Mixin 使用': MixinOnePage(),
    'Performance': PerformanceOnePage(),
    'FlatButton': PerformanceListOnePage(),
    '自定义 Button': PerformanceListTwoPage(),
    '模拟组件耗时': PerformanceTimeWidgetPage(),
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'Navigreation',
            onPressed: () => debugPrint('Navigreation button is pressed'),
          ),
          title: Text("skill"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                debugPrint('Search button is pressed');
              },
            ),
            IconButton(
              icon: Icon(Icons.more_horiz),
              tooltip: 'More',
              onPressed: () => debugPrint('More button is pressed'),
            )
          ],
        ),
        body: ListView.separated(
          itemCount: pageMap.length,
          itemBuilder: (BuildContext context, int index) {
            String title = pageMap.keys.elementAt(index);
            return ListTile(
              title: Text("$title"),
              onTap: () {
                _itemClick(index);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return index % 2 == 0 ? Divider(color: Colors.green) : Divider(color: Colors.blue);
          },
        ),
    );
  }

  void _itemClick(int index) {
    Navigator.of(context).push(
        MaterialPageRoute(builder:(BuildContext context){
          return pageMap.values.elementAt(index);
        })
    );
  }

}