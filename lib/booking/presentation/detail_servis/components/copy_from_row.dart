import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class CopyFromRow extends StatefulWidget {
  const CopyFromRow({
    required this.label,
    required this.onTap,
    super.key,
    this.showChevron = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  State<CopyFromRow> createState() => _CopyFromRowState();
}

class _CopyFromRowState extends State<CopyFromRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: _focused
                ? BoxDecoration(
                    border: Border.all(color: ext.focusRing, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  )
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.content_copy_rounded,
                  size: 16,
                  color: ext.textAccent,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelLarge?.copyWith(
                      color: ext.textAccent,
                    ),
                  ),
                ),
                if (widget.showChevron) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: ext.textAccent,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
