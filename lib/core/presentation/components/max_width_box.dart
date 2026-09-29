import 'package:flutter/material.dart';

class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({
    required this.maxWidth,
    required this.child,
    this.alignment = Alignment.topCenter,
    super.key,
  });

  final double maxWidth;
  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
