import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_strip_item.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_view_model.dart';

List<DateTime> _dateRange(DateTime today) => [
  for (var i = 0; i <= scheduleSearchWindowDays; i++)
    today.add(Duration(days: i)),
];

class DateStrip extends StatelessWidget {
  const DateStrip({
    required this.today,
    required this.selectedDate,
    required this.onSelect,
    super.key,
  });

  final DateTime today;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final dates = _dateRange(today);
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = dates[index];
          return DateStripItem(
            date: date,
            today: date == today,
            selected: date == selectedDate,
            onTap: () => onSelect(date),
          );
        },
      ),
    );
  }
}
