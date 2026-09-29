import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class DateGridCell extends StatelessWidget {
  const DateGridCell({
    required this.date,
    required this.selected,
    required this.today,
    required this.onTap,
    super.key,
  }) : outside = false;

  const DateGridCell.outside({super.key})
    : date = null,
      selected = false,
      today = false,
      onTap = null,
      outside = true;

  final DateTime? date;
  final bool selected;
  final bool today;
  final bool outside;
  final VoidCallback? onTap;

  static const height = 48.0;

  static final _weekdayFormat = DateFormat('EEE', 'id_ID');
  static final _monthFormat = DateFormat('MMM', 'id_ID');

  @override
  Widget build(BuildContext context) {
    final date = this.date;
    if (outside || date == null) return const SizedBox(height: height);

    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final label =
        '${_weekdayFormat.format(date)}, ${date.day} '
        '${_monthFormat.format(date)}${today ? ' (Hari ini)' : ''}';

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? scheme.primaryContainer : null,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected
                        ? ext.borderAccent
                        : (today ? ext.borderDefault : Colors.transparent),
                    width: selected ? 2 : 1,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${date.day}',
                    style: textTheme.titleSmall?.copyWith(
                      color: selected
                          ? scheme.onPrimaryContainer
                          : scheme.onSurface,
                    ),
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
