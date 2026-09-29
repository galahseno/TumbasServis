import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class TsDialogChoice<T> {
  const TsDialogChoice({required this.label, required this.value, this.icon});

  final String label;
  final T value;
  final IconData? icon;
}

class _DismissIntent extends Intent {
  const _DismissIntent();
}

class _TsDialogShell extends StatelessWidget {
  const _TsDialogShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isPhone = width < 600;

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): _DismissIntent(),
      },
      child: Actions(
        actions: {
          _DismissIntent: CallbackAction<_DismissIntent>(
            onInvoke: (_) => Navigator.of(context).maybePop(),
          ),
        },
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isPhone ? 24 : (width - 560) / 2,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isPhone ? double.infinity : 560,
            ),
            child: Padding(padding: const EdgeInsets.all(24), child: child),
          ),
        ),
      ),
    );
  }
}

abstract final class TsDialog {
  static Widget _header(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = TsThemeExtension.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 32, color: iconColor ?? ext.danger),
          const SizedBox(height: 12),
        ],
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
        ),
      ],
    );
  }

  static Widget headerBlock(
    BuildContext context, {
    required String title,
    required String message,
  }) => _header(context, title: title, message: message);

  static Future<T?> custom<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) => showDialog<T>(
    context: context,
    builder: (ctx) => _TsDialogShell(child: builder(ctx)),
  );

  static Future<bool?> confirmDestructive(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Hapus',
    String cancelLabel = 'Batal',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => _TsDialogShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(ctx, title: title, message: message),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TsButton(
                    label: cancelLabel,
                    type: TsButtonType.ghost,
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TsButton(
                    label: confirmLabel,
                    type: TsButtonType.danger,
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> confirmSave(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => _TsDialogShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(ctx, title: title, message: message),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TsButton(
                    label: cancelLabel,
                    type: TsButtonType.ghost,
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TsButton(
                    label: confirmLabel,
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String actionLabel = 'Oke',
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => _TsDialogShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(ctx, title: title, message: message),
            const SizedBox(height: 20),
            TsButton(
              label: actionLabel,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  static Future<T?> blockedAction<T>(
    BuildContext context, {
    required String title,
    required String message,
    String actionLabel = 'Mengerti',
    String? secondaryActionLabel,
    T? secondaryActionValue,
  }) {
    return showDialog<T>(
      context: context,
      builder: (ctx) => _TsDialogShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(
              ctx,
              title: title,
              message: message,
              icon: Icons.block_rounded,
              iconColor: TsThemeExtension.of(ctx).warning,
            ),
            const SizedBox(height: 20),
            if (secondaryActionLabel != null)
              Row(
                children: [
                  Expanded(
                    child: TsButton(
                      label: actionLabel,
                      type: TsButtonType.ghost,
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TsButton(
                      label: secondaryActionLabel,
                      onPressed: () =>
                          Navigator.of(ctx).pop(secondaryActionValue),
                    ),
                  ),
                ],
              )
            else
              TsButton(
                label: actionLabel,
                type: TsButtonType.outline,
                onPressed: () => Navigator.of(ctx).pop(),
              ),
          ],
        ),
      ),
    );
  }

  static Future<T?> choiceList<T>(
    BuildContext context, {
    required String title,
    required List<TsDialogChoice<T>> choices,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = TsThemeExtension.of(context);

    return showDialog<T>(
      context: context,
      builder: (ctx) => _TsDialogShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 12),
            for (final choice in choices)
              _ChoiceRow(choice: choice, ext: ext, textTheme: textTheme),
          ],
        ),
      ),
    );
  }
}

class _ChoiceRow<T> extends StatefulWidget {
  const _ChoiceRow({
    required this.choice,
    required this.ext,
    required this.textTheme,
  });

  final TsDialogChoice<T> choice;
  final TsThemeExtension ext;
  final TextTheme textTheme;

  @override
  State<_ChoiceRow<T>> createState() => _ChoiceRowState<T>();
}

class _ChoiceRowState<T> extends State<_ChoiceRow<T>> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.of(context).pop(widget.choice.value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: _focused
                ? BoxDecoration(
                    border: Border.all(color: widget.ext.focusRing, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: Row(
              children: [
                if (widget.choice.icon != null) ...[
                  Icon(
                    widget.choice.icon,
                    size: 20,
                    color: widget.ext.textBody,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    widget.choice.label,
                    style: widget.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
