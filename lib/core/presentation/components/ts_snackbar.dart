import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum _TsSnackbarKind { success, info, error }

abstract final class TsSnackbar {
  static void success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool aboveNavBar = false,
  }) => _show(
    context,
    message,
    _TsSnackbarKind.success,
    actionLabel,
    onAction,
    aboveNavBar,
  );

  static void info(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool aboveNavBar = false,
  }) => _show(
    context,
    message,
    _TsSnackbarKind.info,
    actionLabel,
    onAction,
    aboveNavBar,
  );

  static void error(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool aboveNavBar = false,
  }) => _show(
    context,
    message,
    _TsSnackbarKind.error,
    actionLabel,
    onAction,
    aboveNavBar,
  );

  static void _show(
    BuildContext context,
    String message,
    _TsSnackbarKind kind,
    String? actionLabel,
    VoidCallback? onAction,
    bool aboveNavBar,
  ) {
    final ext = TsThemeExtension.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasAction = actionLabel != null && onAction != null;
    final messenger = ScaffoldMessenger.of(context);

    final IconData icon = switch (kind) {
      _TsSnackbarKind.success => Icons.check_circle_rounded,
      _TsSnackbarKind.info => Icons.info_rounded,
      _TsSnackbarKind.error => Icons.error_rounded,
    };

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        elevation: 0,
        duration: hasAction || kind == _TsSnackbarKind.error
            ? const Duration(hours: 1)
            : const Duration(seconds: 4),
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: aboveNavBar ? 76 : 16,
        ),
        content: Row(
          children: [
            Icon(icon, size: 20, color: ext.textOnInverse),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: textTheme.bodyMedium?.copyWith(color: ext.textOnInverse),
              ),
            ),
          ],
        ),
        action: hasAction
            ? SnackBarAction(
                label: actionLabel,
                textColor: ext.accentOnInverse,
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  onAction();
                },
              )
            : null,
      ),
    );
  }
}
