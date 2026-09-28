import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

extension TimeSlotJsonX on Map<String, dynamic> {
  TimeSlot toTimeSlot() => TimeSlot(
    date: DateTime.parse(this['date'] as String),
    hour: this['hour'] as int,
    capacity: this['capacity'] as int,
    booked: this['booked'] as int,
  );
}

extension TimeSlotJsonWriterX on TimeSlot {
  Map<String, dynamic> toTimeSlotJson() => {
    'date': date.toIso8601String(),
    'hour': hour,
    'capacity': capacity,
    'booked': booked,
  };
}
