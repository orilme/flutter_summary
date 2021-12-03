import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 自定义高度tab_bar
@Deprecated('请使用RikiScaledTabBar')
class RikiTabBar extends TabBar {
  const RikiTabBar({
    Key? key,
    required List<Widget> tabs,
    this.height,
    TabController? controller,
    bool isScrollable = false,
    Color? indicatorColor,
    double indicatorWeight = 2.0,
    EdgeInsets indicatorPadding = EdgeInsets.zero,
    Decoration? indicator,
    TabBarIndicatorSize? indicatorSize,
    Color? labelColor,
    TextStyle? labelStyle,
    EdgeInsets? labelPadding,
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ValueChanged<int>? onTap,
  }) : super(
          key: key,
          tabs: tabs,
          controller: controller,
          isScrollable: isScrollable,
          indicatorColor: indicatorColor,
          indicatorWeight: indicatorWeight,
          indicatorPadding: indicatorPadding,
          indicator: indicator,
          indicatorSize: indicatorSize,
          labelColor: labelColor,
          labelStyle: labelStyle,
          labelPadding: labelPadding,
          unselectedLabelColor: unselectedLabelColor,
          unselectedLabelStyle: unselectedLabelStyle,
          dragStartBehavior: dragStartBehavior,
          onTap: onTap,
        );

  final double? height;

  @override
  Size get preferredSize {
    for (Widget item in tabs) {
      if (item is Tab) {
        final Tab tab = item;
        if (tab.text != null && tab.icon != null) return Size.fromHeight(72 + indicatorWeight);
      }
    }
    return Size.fromHeight((height ?? 46) + indicatorWeight);
  }
}
