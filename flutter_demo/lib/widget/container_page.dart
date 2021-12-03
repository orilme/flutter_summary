import 'package:flutter/material.dart';

/// Container控件的大小是调整的吗？Container默认是适配子控件大小的，但当设置对齐方式时Container将会填满父控件。

class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  Color _draggableColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
//        //custom leading buttom
//        leading: IconButton(
//          icon: Icon(Icons.menu),
//          tooltip: 'Navigreation',
//          onPressed: () => debugPrint('Navigreation button is pressed'),
//        ),
          title: Text("容器组件/自定义AppBar"),
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
        body: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 20.0),
                // padding: EdgeInsets.all(20),
                constraints:
                BoxConstraints.tightFor(width: 150.0, height: 100.0), //卡片大小
                decoration: BoxDecoration(
                  //背景装饰
                  gradient: RadialGradient(
                    //背景径向渐变
                    colors: [Colors.red, Colors.orange],
                    center: Alignment.topLeft,
                    radius: .98,
                  ),
                  boxShadow: [
                    //卡片阴影
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 4.0,
                    )
                  ],
                ),
                transform: Matrix4.rotationZ(.2), //卡片倾斜变换'package:flutter/material.dart';
                alignment: Alignment.center, //卡片内文字居中
                child: Text(
                  //卡片文字
                  "5.20", style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50,bottom: 10), child: Text('FittedBox')),
              Container(
                height: 150,
                width: 150,
                color: Colors.green,
                child: FittedBox(
                  // alignment: Alignment.topLeft,
                  /*
                  fit参数表示了子控件的填充方式，说明如下：
                  fill：填充父组件，宽高比发生变化。
                  contain：等比拉伸，但子控件不能超出父控件。
                  cover：尽可能的小，等比拉伸充满父控件。
                  fitWidth：等比拉伸，宽充满父控件。
                  fitHeight：等比拉伸，高充满父控件。
                  none：默认子控件居中，不做拉伸处理，超出父控件的部分裁剪。
                  scaleDown：在子控件为Image且缩小的情况和contain一样，否则和none一样。
                  */
                  fit: BoxFit.contain,
                  child: Container(
                    height: 50,
                    width: 80,
                    color: Colors.red,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10), child: Text('DecoratedBox')),
              DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.blue),
                child: Text('DecoratedBox'),
              ),
              SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: Text('DecoratedBox'),
              ),
              SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                child: Text('DecoratedBox'),
              ),
              Padding(padding: EdgeInsets.all(10), child: Text('DecorationImage')),
              Row(
                children: [
                  Center(child: SizedBox(width: 10)),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      image:  DecorationImage(
                        image: NetworkImage(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      height: 130,
                      width: 130,
                      child: Text("哈哈哈"),
                    ),
                  ),
                  SizedBox(width: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      image:  DecorationImage(
                        image: NetworkImage(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      height: 130,
                      width: 130,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(10), child: Text('RadialGradient')),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.5, -0.6),
                    radius: 0.15,
                    colors: <Color>[
                      const Color(0xFFEEE444),
                      const Color(0xFF111555),
                    ],
                    stops: <double>[0.9, 1.0],
                  ),
                ),
                child: Container(
                  height: 150,
                  width: 150,
                ),
              )
            ],
          ),
        )
    );
  }
}
