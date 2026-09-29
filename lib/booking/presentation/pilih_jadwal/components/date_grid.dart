import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_grid_cell.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class DateGrid extends StatelessWidget {
  const DateGrid({
    required this.today,
    required this.selectedDate,
    required this.windowDays,
    required this.onSelect,
    super.key,
  });

  final DateTime today;
  final DateTime selectedDate;
  final int windowDays;
  final ValueChanged<DateTime> onSelect;

  static final _weekdayFormat = DateFormat('EEE', 'id_ID');
  static final _monthFormat = DateFormat('MMM', 'id_ID');

  DateTime get _gridStart =>
      DateTime(today.year, today.month, today.day - (today.weekday - 1));

  DateTime get _lastDay =>
      DateTime(today.year, today.month, today.day + windowDays);

  int get _rowCount {
    final days = _lastDay.difference(_gridStart).inDays + 1;
    return (days / 7).ceil();
  }

  String get _rangeLabel {
    final last = _lastDay;
    if (today.year == last.year && today.month == last.month) {
      return '${_monthFormat.format(today)} ${today.year}';
    }
    if (today.year == last.year) {
      return '${_monthFormat.format(today)} – ${_monthFormat.format(last)} '
          '${last.year}';
    }
    return '${_monthFormat.format(today)} ${today.year} – '
        '${_monthFormat.format(last)} ${last.year}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final start = _gridStart;

    Widget weekdayHeader(int index) => Expanded(
      child: Center(
        child: Text(
          _weekdayFormat.format(
            DateTime(start.year, start.month, start.day + index),
          ),
          maxLines: 1,
          style: textTheme.labelSmall?.copyWith(color: ext.textFaint),
        ),
      ),
    );

    Widget cellFor(int offset) {
      final date = DateTime(start.year, start.month, start.day + offset);
      final inWindow = !date.isBefore(today) && !date.isAfter(_lastDay);
      return Expanded(
        child: inWindow
            ? DateGridCell(
                date: date,
                selected: date == selectedDate,
                today: date == today,
                onTap: () => onSelect(date),
              )
            : const DateGridCell.outside(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tanggal kedatangan',
            style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
          ),
          Text(
            _rangeLabel,
            style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
          ),
          const SizedBox(height: 12),
          Row(children: [for (var i = 0; i < 7; i++) weekdayHeader(i)]),
          const SizedBox(height: 4),
          for (var row = 0; row < _rowCount; row++)
            Row(children: [for (var i = 0; i < 7; i++) cellFor(row * 7 + i)]),
        ],
      ),
    );
  }
}
