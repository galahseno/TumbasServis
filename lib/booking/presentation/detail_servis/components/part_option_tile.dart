import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class PartOptionTile extends StatefulWidget {
  const PartOptionTile({
    required this.name,
    required this.subtitle,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String name;
  final String subtitle;
  final bool selected;
  final ValueChanged<bool> onChanged;

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
          onTap: () => widget.onChanged(!widget.selected),
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
                Icon(
                  widget.selected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color: widget.selected ? ext.accent : ext.textFaint,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                        ),
                      ),
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
