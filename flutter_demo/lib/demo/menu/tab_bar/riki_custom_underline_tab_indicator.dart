import 'package:flutter/material.dart';

///
/// 自定义下划线(两端圆角)Indicator
///
/// Created by Jack Zhang on 3/17/21 .
///
@Deprecated('请使用RikiUnderlineTabIndicator')
class RikiCustomUnderlineTabIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const RikiCustomUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.wantWidth = 20,
  }) : super();

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the
  /// tab indicator's bounds in terms of its (centered) tab widget with
  /// [TabIndicatorSize.label], or the entire tab with [TabIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

  final double wantWidth; //传入的指示器宽度，默认16
  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is UnderlineTabIndicator) {
      return RikiCustomUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is UnderlineTabIndicator) {
      return RikiCustomUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, wantWidth, onChanged);
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, this.wantWidth, VoidCallback? onChanged) : super(onChanged);
  final double wantWidth;
  final RikiCustomUnderlineTabIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;

  EdgeInsetsGeometry get insets => decoration.insets;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    //希望的宽度
    // double wantWidth = 16;
    //取中间坐标
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(
      cw - wantWidth / 2,
      indicator.bottom - borderSide.width,
      wantWidth,
      borderSide.width,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // assert(configuration != null);
    // assert(configuration.size != null);
    // final Rect rect = offset & configuration.size;
    // final TextDirection textDirection = configuration.textDirection;
    // final Rect indicator = _indicatorRectFor(rect, textDirection).deflate(1);
    // final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.round;
    // //主要是修改此处
    // canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);

    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = _indicatorRectFor(rect, textDirection);
    final Paint paint = borderSide.toPaint();
    canvas.drawRRect(RRect.fromRectAndRadius(indicator, Radius.circular(0.5)), paint);
  }
}
