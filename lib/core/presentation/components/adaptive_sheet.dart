import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

Future<T?> showAdaptiveSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  double maxWidth = 560,
  bool useSafeArea = false,
  Color? backgroundColor,
  ShapeBorder? shape,
  BoxConstraints? constraints,
}) {
  if (context.windowSizeClass.isCompact) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: useSafeArea,
      showDragHandle: false,
      backgroundColor: backgroundColor,
      shape: shape,
      constraints: constraints,
      builder: builder,
    );
  }
  return showDialog<T>(
    context: context,
    builder: (dialogContext) {
      final height = MediaQuery.sizeOf(dialogContext).height;
      return Dialog(
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: height * 0.9,
          ),
          child: builder(dialogContext),
        ),
      );
    },
  );
}
