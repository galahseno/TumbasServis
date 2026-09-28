import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum TsIconButtonStyle { standard, tonal }

class TsIconButton extends StatefulWidget {
  const TsIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.style = TsIconButtonStyle.standard,
    this.badgeCount,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final TsIconButtonStyle style;
  final int? badgeCount;
  final String? semanticLabel;

  @override
  State<TsIconButton> createState() => _TsIconButtonState();
}

class _TsIconButtonState extends State<TsIconButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final extension = TsThemeExtension.of(context);
    final enabled = widget.onPressed != null;
    final tonal = widget.style == TsIconButtonStyle.tonal;

    final Color background;
    final Color foreground;
    if (!enabled) {
      background = tonal ? scheme.surfaceContainerLow : Colors.transparent;
      foreground = extension.textFaint;
    } else if (tonal) {
      background = scheme.primaryContainer;
      foreground = scheme.onPrimaryContainer;
    } else {
      background = Colors.transparent;
      foreground = extension.textBody;
    }

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: enabled,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Focus(
          onFocusChange: (value) => setState(() => _focused = value),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                color: background,
                shape: CircleBorder(
                  side: _focused
                      ? BorderSide(color: extension.focusRing, width: 2)
                      : BorderSide.none,
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.onPressed,
                  highlightColor: extension.statePressed,
                  splashColor: extension.statePressed,
                  child: Center(
                    child: Icon(widget.icon, size: 24, color: foreground),
                  ),
                ),
              ),
              if (widget.badgeCount != null && widget.badgeCount! > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    decoration: BoxDecoration(
                      color: extension.danger,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.badgeCount! > 9 ? '9+' : '${widget.badgeCount}',
                      style: const TextStyle(
                        fontFamily: 'Exo 2',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
