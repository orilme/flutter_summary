import 'package:flutter/material.dart';

class GridViewPage extends StatefulWidget {
  const GridViewPage({Key? key}) : super(key: key);

  @override
  _GridViewPageState createState() => _GridViewPageState();
}

class _GridViewPageState extends State<GridViewPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("GridView")),
        backgroundColor: Colors.black12,
        body: Column(
          children: [
            Container(
              height: 200,
              color: Colors.green,
              child: GridView.count(
                //设置滚动方向
                scrollDirection: Axis.vertical,
                //设置列数
                crossAxisCount: 3,
                //设置内边距
                padding: EdgeInsets.all(10),
                //设置横向间距
                crossAxisSpacing: 30,
                //设置主轴间距
                mainAxisSpacing: 20,
                children: _getData(),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              color: Colors.red,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // 设置列数
                  crossAxisCount: 3,
                  // 设置横向间距
                  crossAxisSpacing: 30,
                  // 设置主轴间距
                  mainAxisSpacing: 10,
                  // 子控件宽高比，默认 1
                  childAspectRatio: 0.9,
                ),
                scrollDirection: Axis.vertical,
                itemCount: listData.length,
                itemBuilder:(context,index){
                  return Container(
                    child: Column(
                      children: [
                        Image.network(
                          listData[index]["image"],
                          fit: BoxFit.cover,
                        ),
                        Text(
                          listData[index]["title"],
                          textAlign:TextAlign.center,
                        )
                      ],
                    ),
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black26, width: 1)),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              color: Colors.purple,
              child: GridView.custom(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                childrenDelegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                      color: Colors.primaries[index % Colors.primaries.length]);
                }, childCount: 10),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 150,
              color: Colors.yellow,
              child: GridView.extent(
                maxCrossAxisExtent: 100,
                children: List.generate(10, (i) {
                  return Container(
                    color: Colors.primaries[i % Colors.primaries.length],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List listData = [
    {
      "title": "标题1",
      "author": "内容1",
      "image": "https://www.itying.com/images/flutter/1.png"
    },
    {
      "title": "标题2",
      "author": "内容2",
      "image": "https://www.itying.com/images/flutter/2.png"
    },
    {
      "title": "标题3",
      "author": "内容3",
      "image": "https://www.itying.com/images/flutter/3.png"
    },
    {
      "title": "标题4",
      "author": "内容4",
      "image": "https://www.itying.com/images/flutter/4.png"
    },
    {
      "title": "标题5",
      "author": "内容5",
      "image": "https://www.itying.com/images/flutter/5.png"
    }
  ];

  List<Widget> _getData() {
    List<Widget>? list = [];
    for (var i = 0; i < listData.length; i++) {
      list.add(Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Image.network(
                listData[i]["image"],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              listData[i]["title"],
              textAlign:TextAlign.center,
            )
          ],
        ),
        decoration:
        BoxDecoration(border: Border.all(color: Colors.black26, width: 1)),
      ));
    }
    return list;
  }
}
