import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class UnitRailItem {
  const UnitRailItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final String id;
  final String title;
  final String subtitle;
  final UnitChipStatus status;
}

class UnitRail extends StatelessWidget {
  const UnitRail({
    required this.items,
    required this.activeId,
    required this.onSelect,
    super.key,
  });

  static const width = 252.0;

  final List<UnitRailItem> items;
  final String? activeId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text(
            'Motor',
            style: textTheme.labelLarge?.copyWith(color: ext.textMuted),
          ),
        ),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _UnitRailRow(
              item: item,
              active: item.id == activeId,
              onTap: () => onSelect(item.id),
            ),
          ),
      ],
    );
  }
}

class _UnitRailRow extends StatelessWidget {
  const _UnitRailRow({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final UnitRailItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final Color glyphColor;
    final IconData glyphIcon;
    switch (item.status) {
      case UnitChipStatus.complete:
        glyphColor = ext.success;
        glyphIcon = Icons.check_circle_rounded;
      case UnitChipStatus.error:
        glyphColor = ext.danger;
        glyphIcon = Icons.error_rounded;
      case UnitChipStatus.incomplete:
        glyphColor = ext.textFaint;
        glyphIcon = Icons.radio_button_unchecked_rounded;
    }
    final border = item.status == UnitChipStatus.error
        ? ext.danger
        : (active ? ext.borderAccent : ext.borderDefault);

    return Semantics(
      button: true,
      selected: active,
      label: '${item.title}, ${item.subtitle}',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 62),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: active ? scheme.primaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: active ? 2 : 1),
            ),
            child: Row(
              children: [
                Icon(glyphIcon, size: 20, color: glyphColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          color: active
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
