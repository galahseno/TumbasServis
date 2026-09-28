import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

extension TimeSlotFormatX on TimeSlot {
  String get slotKey => '${date.year}-${date.month}-${date.day}|$hour';

  String get auditLabel {
    final dateLabel =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    return '$dateLabel ${hour.toString().padLeft(2, '0')}:00';
  }
}
