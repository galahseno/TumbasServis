import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum TsButtonType {
  primary,
  secondary,
  outline,
  ghost,
  danger,
  dangerOutline,
  dangerGhost,
}

class _Palette {
  const _Palette({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}

class TsButton extends StatefulWidget {
  const TsButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.type = TsButtonType.primary,
    this.isLoading = false,
    this.leadingIcon,
    this.compact = false,
    this.fullWidth = true,
    this.emphasized = false,
    this.loadingLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final TsButtonType type;
  final bool isLoading;
  final IconData? leadingIcon;

  final bool compact;
  final bool fullWidth;

  final bool emphasized;

  final String? loadingLabel;

  @override
  State<TsButton> createState() => _TsButtonState();
}

class _TsButtonState extends State<TsButton> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  _Palette _paletteFor(ColorScheme scheme, TsThemeExtension ext) {
    if (!_enabled) {
      switch (widget.type) {
        case TsButtonType.primary:
        case TsButtonType.danger:
          return _Palette(
            background: scheme.surfaceContainerLow,
            foreground: ext.textFaint,
          );
        case TsButtonType.secondary:
          return _Palette(
            background: scheme.surfaceContainerLow,
            foreground: ext.textFaint,
          );
        case TsButtonType.outline:
        case TsButtonType.dangerOutline:
        case TsButtonType.ghost:
        case TsButtonType.dangerGhost:
          return _Palette(
            background: Colors.transparent,
            foreground: ext.textFaint,
            border:
                widget.type == TsButtonType.ghost ||
                    widget.type == TsButtonType.dangerGhost
                ? null
                : ext.borderDefault,
          );
      }
    }

    switch (widget.type) {
      case TsButtonType.primary:
        return _Palette(
          background: _pressed ? ext.accentPressed : scheme.primary,
          foreground: scheme.onPrimary,
        );
      case TsButtonType.danger:
        return _Palette(
          background: _pressed ? ext.dangerPressed : ext.dangerText,
          foreground: scheme.onError,
        );
      case TsButtonType.secondary:
        return _Palette(
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
          border: _pressed ? ext.borderAccent : null,
        );
      case TsButtonType.outline:
        return _Palette(
          background: Colors.transparent,
          foreground: scheme.onSurface,
          border: _pressed ? ext.borderAccent : scheme.outline,
        );
      case TsButtonType.dangerOutline:
        return _Palette(
          background: Colors.transparent,
          foreground: ext.dangerText,
          border: _pressed ? ext.dangerPressed : ext.danger,
        );
      case TsButtonType.ghost:
        return _Palette(
          background: _pressed ? scheme.primaryContainer : Colors.transparent,
          foreground: _pressed ? scheme.onPrimaryContainer : ext.textAccent,
        );
      case TsButtonType.dangerGhost:
        return _Palette(
          background: _pressed ? ext.dangerSoft : Colors.transparent,
          foreground: ext.dangerText,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final palette = _paletteFor(scheme, ext);
    final height = widget.compact ? 40.0 : 48.0;
    final labelStyle = Theme.of(
      context,
    ).textTheme.labelLarge?.copyWith(color: palette.foreground);

    final spinner = SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(palette.foreground),
      ),
    );
    final content = widget.isLoading
        ? (widget.loadingLabel == null
              ? spinner
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    spinner,
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.loadingLabel!,
                        style: labelStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ))
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(widget.leadingIcon, size: 20, color: palette.foreground),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  style: labelStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(12),
        border: palette.border != null
            ? Border.all(color: palette.border!, width: 1)
            : null,
        boxShadow: widget.emphasized && widget.type == TsButtonType.primary
            ? ext.shadowAccent
            : null,
      ),
      alignment: Alignment.center,
      child: content,
    );

    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      child: GestureDetector(
        onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
        onTap: _enabled ? widget.onPressed : null,
        child: Semantics(
          button: true,
          enabled: _enabled,
          label: widget.label,
          child: SizedBox(
            width: widget.fullWidth ? double.infinity : null,
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              alignment: Alignment.center,
              decoration: _focused
                  ? BoxDecoration(
                      border: Border.all(color: ext.focusRing, width: 2),
                      borderRadius: BorderRadius.circular(14),
                    )
                  : null,
              padding: _focused ? const EdgeInsets.all(2) : EdgeInsets.zero,
              child: button,
            ),
          ),
        ),
      ),
    );
  }
}
