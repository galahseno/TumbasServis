import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class TsChip extends StatefulWidget {
  const TsChip({
    required this.label,
    required this.selected,
    super.key,
    this.onSelected,
    this.leadingIcon,
  });

  final String label;
  final bool selected;

  final ValueChanged<bool>? onSelected;
  final IconData? leadingIcon;

  @override
  State<TsChip> createState() => _TsChipState();
}

class _TsChipState extends State<TsChip> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final enabled = widget.onSelected != null;

    final Color background;
    final Color foreground;
    final Color border;
    if (!enabled) {
      background = Colors.transparent;
      foreground = ext.textFaint;
      border = ext.borderDefault;
    } else if (widget.selected) {
      background = scheme.primaryContainer;
      foreground = scheme.onPrimaryContainer;
      border = ext.borderAccent;
    } else {
      background = Colors.transparent;
      foreground = ext.textBody;
      border = scheme.outline;
    }

    return Semantics(
      button: true,
      selected: widget.selected,
      enabled: enabled,
      child: SizedBox(
        height: 48,
        child: Focus(
          onFocusChange: (value) => setState(() => _focused = value),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: enabled
                    ? () => widget.onSelected!(!widget.selected)
                    : null,
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _focused ? ext.focusRing : border,
                      width: _focused ? 2 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.selected) ...[
                        Icon(Icons.check_rounded, size: 16, color: foreground),
                        const SizedBox(width: 6),
                      ] else if (widget.leadingIcon != null) ...[
                        Icon(widget.leadingIcon, size: 16, color: foreground),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelLarge?.copyWith(
                            color: foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
