import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';

class NotificationGroupHeader extends StatelessWidget {
  const NotificationGroupHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String title;

  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
          ),
        ),
        if (actionLabel != null)
          TsButton(
            label: actionLabel!,
            type: TsButtonType.ghost,
            compact: true,
            fullWidth: false,
            onPressed: onAction,
          ),
      ],
    );
  }
}
