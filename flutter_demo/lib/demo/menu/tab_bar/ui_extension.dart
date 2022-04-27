import 'package:flutter/material.dart';
import 'package:flutter_demo/base/utils/screen_util/flutter_screenutil.dart';

/// riki空widget
class RikiEmpty {
  /// 普通的空Widget
  static Widget get ui => SizedBox(width: 0, height: 0);

  /// Sliver中的空Widget
  static Widget get sliver => SliverToBoxAdapter(child: ui);
}

/// 空Widget
@Deprecated('请使用RikiEmpty')
class Empty {
  /// 普通的空Widget
  static Widget get ui => SizedBox(width: 0, height: 0);

  /// Sliver中的空Widget
  static Widget get sliver => SliverToBoxAdapter(child: ui);
}

/// 间隙
extension GapExtension on num {
  /// 横向间隔
  /// 使用方法为 [1.hGap]
  Widget get hGap => SizedBox(width: this.w);

  /// 纵向间隔
  /// 使用方法为 [1.vGap]
  Widget get vGap => SizedBox(height: this.w);
}

/// 分割线
extension NumLineExtension on num {
  /// 横线
  /// [color] 线段颜色 默认[0x0d000000]
  /// [margin] 线段间距 默认无
  /// [width] 线段宽度
  Widget hLine({
    Color color = const Color(0x0d000000),
    EdgeInsets margin = EdgeInsets.zero,
    double? width,
  }) =>
      Container(
        margin: margin,
        width: width,
        height: this.w,
        color: color,
      );

  /// 竖线
  /// [color] 线段颜色 默认[0x0d000000]
  /// [margin] 线段间距 默认无
  /// [height] 线段高度
  Widget vLine({
    Color color = const Color(0x0d000000),
    EdgeInsets margin = EdgeInsets.zero,
    double? height,
  }) =>
      Container(
        margin: margin,
        width: this.w,
        height: height,
        color: color,
      );
}
