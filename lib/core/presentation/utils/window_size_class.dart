import 'package:flutter/widgets.dart';

enum WindowSizeClass {
  compact,
  medium,
  expanded,
  large;

  static const double mediumMinWidth = 600;
  static const double expandedMinWidth = 840;
  static const double largeMinWidth = 1200;

  static const double tabletShortestSide = 600;

  static WindowSizeClass fromWidth(double width) {
    if (width >= largeMinWidth) return large;
    if (width >= expandedMinWidth) return expanded;
    if (width >= mediumMinWidth) return medium;
    return compact;
  }

  bool isAtLeast(WindowSizeClass other) => index >= other.index;

  bool get isCompact => this == compact;
}

bool isTabletSize(Size size) =>
    size.shortestSide >= WindowSizeClass.tabletShortestSide;

extension WindowSizeContext on BuildContext {
  WindowSizeClass get windowSizeClass =>
      WindowSizeClass.fromWidth(MediaQuery.sizeOf(this).width);

  bool get isTablet => isTabletSize(MediaQuery.sizeOf(this));
}
