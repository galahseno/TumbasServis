import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class DateStripItem extends StatelessWidget {
  const DateStripItem({
    required this.date,
    required this.selected,
    required this.today,
    required this.onTap,
    super.key,
  });

  final DateTime date;
  final bool selected;
  final bool today;
  final VoidCallback onTap;

  static final _weekdayFormat = DateFormat('EEE', 'id_ID');
  static final _monthFormat = DateFormat('MMM', 'id_ID');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final weekday = _weekdayFormat.format(date);
    final month = _monthFormat.format(date);

    return Semantics(
      button: true,
      selected: selected,
      label: '$weekday, ${date.day} $month${today ? ' (Hari ini)' : ''}',
      child: SizedBox(
        width: 64,
        height: 72,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: selected ? scheme.primaryContainer : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? ext.borderAccent : ext.borderDefault,
                  width: selected ? 2 : 1,
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    weekday,
                    style: textTheme.labelMedium?.copyWith(
                      color: selected
                          ? scheme.onPrimaryContainer
                          : ext.textMuted,
                    ),
                  ),
                  Text(
                    '${date.day}',
                    style: textTheme.titleMedium?.copyWith(
                      color: selected
                          ? scheme.onPrimaryContainer
                          : scheme.onSurface,
                    ),
                  ),
                  Text(
                    month,
                    style: textTheme.labelSmall?.copyWith(
                      color: selected
                          ? scheme.onPrimaryContainer
                          : ext.textFaint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
