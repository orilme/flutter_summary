import 'package:flutter/material.dart';
import 'package:flutter_demo/common/screen_util/flutter_screenutil.dart';

// /*
// * 此类相当于自定义系统的UnderlineTabIndicator
// * 用于自定义指示器的下标宽度 第70行
// *
// * */

class RikiUnderlineTabIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const RikiUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0),
    double width = 2.0,
    this.insets = EdgeInsets.zero,
    this.indicatorWidth = 25,
  }) ;


  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the
  /// tab indicator's bounds in terms of its (centered) tab widget with
  /// [TabIndicatorSize.label], or the entire tab with [TabIndicatorSize.tab].
  final EdgeInsetsGeometry insets;
  //新增属性指示器下表宽度
  final double indicatorWidth;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is UnderlineTabIndicator) {
      return RikiUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is UnderlineTabIndicator) {
      return RikiUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter( [VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged,indicatorWidth);
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged,this.indicatorWidth)
      :
        super(onChanged);

  final RikiUnderlineTabIndicator decoration;
  final double indicatorWidth;
  BorderSide get borderSide => decoration.borderSide;

  EdgeInsetsGeometry get insets => decoration.insets;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    ///这里修改为自己想要宽度
    //取中间坐标
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(cw - indicatorWidth / 2,
        indicator.bottom - borderSide.width, indicatorWidth, borderSide.width);
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final gradient = new LinearGradient(
      colors: [Color(0xff00CDEC), Color(0xff00ED7D)],
    );

    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator =
    _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.5);
    final Paint paint = borderSide.toPaint()..shader = gradient.createShader(indicator);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          indicator,
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          topLeft: Radius.circular(5.w),
          topRight: Radius.circular(5.w),
        ),
        paint);

  }
}