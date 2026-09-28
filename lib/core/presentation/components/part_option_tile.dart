import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class PartOptionTile extends StatefulWidget {
  const PartOptionTile({
    required this.name,
    required this.subtitle,
    required this.selected,
    required this.onChanged,
    super.key,
    this.onTap,
    this.disabled = false,
    this.reasonText,
    this.showCheckbox = true,
  });

  final String name;
  final String subtitle;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTap;
  final bool disabled;
  final String? reasonText;
  final bool showCheckbox;

  @override
  State<PartOptionTile> createState() => _PartOptionTileState();
}

class _PartOptionTileState extends State<PartOptionTile> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              widget.onTap ??
              (widget.disabled
                  ? null
                  : () => widget.onChanged(!widget.selected)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: _focused
                  ? Border.all(color: ext.focusRing, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                if (widget.showCheckbox) ...[
                  GestureDetector(
                    onTap: widget.disabled
                        ? null
                        : () => widget.onChanged(!widget.selected),
                    child: Icon(
                      widget.selected
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      color: widget.disabled
                          ? ext.textFaint
                          : (widget.selected ? ext.accent : ext.textFaint),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: textTheme.bodyLarge?.copyWith(
                          color: widget.disabled
                              ? ext.textFaint
                              : scheme.onSurface,
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                        ),
                      ),
                      if (widget.reasonText != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 14,
                              color: ext.warning,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.reasonText!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: ext.warningText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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
