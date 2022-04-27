import 'package:flutter/material.dart';
import 'dart:math';

/*
CustomPaint构造函数
CustomPaint({
  Key key,
  this.painter,
  this.foregroundPainter,
  this.size = Size.zero,
  this.isComplex = false,
  this.willChange = false,
  Widget child, //子节点，可以为空
})
 */
/// painter: 背景画笔，会显示在子节点后面;
/// foregroundPainter: 前景画笔，会显示在子节点前面
/// size：当child为null时，代表默认绘制区域大小，如果有child则忽略此参数，画布尺寸则为child尺寸。如果有child但是想指定画布为特定大小，可以使用SizeBox包裹CustomPaint实现。
/// isComplex：是否复杂的绘制，如果是，Flutter会应用一些缓存策略来减少重复渲染的开销。
/// willChange：和isComplex配合使用，当启用缓存时，该属性代表在下一帧中绘制是否会改变。
///
/// 注意
// 如果CustomPaint有子节点，为了避免子节点不必要的重绘并提高性能，通常情况下都会将子节点包裹在RepaintBoundary组件中，
// 这样会在绘制时就会创建一个新的绘制层（Layer），其子组件将在新的Layer上绘制，而父组件将在原来Layer上绘制，
// 也就是说RepaintBoundary 子组件的绘制将独立于父组件的绘制，RepaintBoundary会隔离其子节点和CustomPaint本身的绘制边界。
// 示例如下：
/*
CustomPaint(
  size: Size(300, 300), //指定画布大小
  painter: MyPainter(),
  child: RepaintBoundary(child:...)),
)
 */

/// CustomPainter
/// CustomPainter 中提定义了一个虚函数paint： void paint(Canvas canvas, Size size);
/// paint有两个参数:
/// Canvas：一个画布，包括各种绘制方法:
// drawLine	画线
// drawPoint	画点
// drawPath	画路径
// drawImage	画图像
// drawRect	画矩形
// drawCircle	画圆
// drawOval	画椭圆
// drawArc	画圆弧
/// Size：当前绘制区域大小

/// 画笔Paint
/// 在Paint中，我们可以配置画笔的各种属性如粗细、颜色、样式等

/// 性能
/// 1. 尽可能的利用好shouldRepaint返回值
// 在UI树重新build时，控件在绘制前都会先调用该方法以确定是否有必要重绘；
// 假如我们绘制的UI不依赖外部状态，即外部状态改变不会影响我们的UI外观，那么就应该返回false；
// 如果绘制依赖外部状态，那么我们就应该在shouldRepaint中判断依赖的状态是否改变，
// 如果已改变则应返回true来重绘，反之则应返回false不需要重绘。
/// 2. 绘制尽可能多的分层
// 在下面五子棋的示例中，我们将棋盘和棋子的绘制放在了一起，这样会有一个问题：
// 由于棋盘始终是不变的，用户每次落子时变的只是棋子，但是如果按照上面的代码来实现，每次绘制棋子时都要重新绘制一次棋盘，这是没必要的。
// 优化的方法就是将棋盘单独抽为一个组件，并设置其shouldRepaint回调值为false，然后将棋盘组件作为背景。
// 然后将棋子的绘制放到另一个组件中，这样每次落子时只需要绘制棋子。

class CanvasPage extends StatefulWidget {
  const CanvasPage({Key? key}) : super(key: key);

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Canvas")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              painter: PurseArcPainter(),
              size: Size.fromHeight(100),
            ),
            // RepaintBoundary(
            //   child: CustomPaint(
            //     size: Size(300, 300), //指定画布大小
            //     painter: MyPainter(),
            //   ),
            // ),
            /// 下面写法发现日志面板输出了很多 “paint”，也就是说在点击按钮的时候发生了多次重绘。
            /// shouldRepaint 我们返回的是false，并且点击刷新按钮也不会触发页面重新构建，那是什么导致的重绘呢？
            /// 要彻底弄清楚这个问题得等到第十四章中介绍 Flutter 绘制原理时才行，现在读者可以简单认为，刷新按钮的画布和CustomPaint的画布是同一个，
            /// 刷新按钮点击时会执行一个水波动画，水波动画执行过程中画布会不停的刷新，所以就导致了CustomPaint 不停的重绘。
            /// 要解决这个问题的方案很简单，给刷新按钮 或 CustomPaint 任意一个添加一个 RepaintBoundary 父组件即可，它可以将生成一个新画布。
            CustomPaint(
              size: Size(300, 300), //指定画布大小
              painter: MyPainter(),
            ),
            //添加一个刷新button
            ElevatedButton(onPressed: () {}, child: Text("刷新"))
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print('paint---');
    var rect = Offset.zero & size;
    //画棋盘
    drawChessboard(canvas, rect);
    //画棋子
    drawPieces(canvas, rect);
  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void drawChessboard(Canvas canvas, Rect rect) {
  //棋盘背景
  var paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill //填充
    ..color = Color(0xFFDCC48C);
  canvas.drawRect(rect, paint);

  //画棋盘网格
  paint
    ..style = PaintingStyle.stroke //线
    ..color = Colors.red
    ..strokeWidth = 3.0;

  //画横线
  for (int i = 0; i <= 15; ++i) {
    double dy = rect.top + rect.height / 15 * i;
    canvas.drawLine(Offset(rect.left, dy), Offset(rect.right, dy), paint);
  }

  for (int i = 0; i <= 15; ++i) {
    double dx = rect.left + rect.width / 15 * i;
    canvas.drawLine(Offset(dx, rect.top), Offset(dx, rect.bottom), paint);
  }
}

//画棋子
void drawPieces(Canvas canvas, Rect rect) {
  double eWidth = rect.width / 15;
  double eHeight = rect.height / 15;
  //画一个黑子
  var paint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;
  //画一个黑子
  canvas.drawCircle(
    Offset(rect.center.dx - eWidth / 2, rect.center.dy - eHeight / 2),
    min(eWidth / 2, eHeight / 2) - 2,
    paint,
  );
  //画一个白子
  paint.color = Colors.white;
  canvas.drawCircle(
    Offset(rect.center.dx + eWidth / 2, rect.center.dy - eHeight / 2),
    min(eWidth / 2, eHeight / 2) - 2,
    paint,
  );
}

class PurseArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint _paint = Paint()
      ..color = Colors.red //画笔颜色
      ..strokeCap = StrokeCap.butt //画笔笔触类型
      ..style = PaintingStyle.fill //绘画风格，默认为填充
      ..strokeWidth = 1.0; //

    final Offset _startPoint = Offset(0, size.height / 3 * 2); //开始位置
    final Offset _controlPoint1 = Offset(size.width / 4, size.height); //控制点
    final Offset _controlPoint2 = Offset(3 * size.width / 4, size.height); //控制点
    final Offset _endPoint = Offset(size.width, size.height / 3 * 2); //结束位置

    final Path _path = Path();
    _path.moveTo(0, 0);
    _path.lineTo(_startPoint.dx, _startPoint.dy);
    _path.cubicTo(_controlPoint1.dx, _controlPoint1.dy, _controlPoint2.dx, _controlPoint2.dy, _endPoint.dx, _endPoint.dy);
    _path.lineTo(_endPoint.dx, 0);
    _path.lineTo(0, 0);
    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(PurseArcPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(PurseArcPainter oldDelegate) => false;
}
