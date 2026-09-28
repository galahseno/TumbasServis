import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/time_formatter.dart';

DateTime slotDateTime(TimeSlot slot) =>
    DateTime(slot.date.year, slot.date.month, slot.date.day, slot.hour);

String slotRecapLabel(TimeSlot slot) =>
    '${DateFormatter.format(slot.date)} · ${TimeFormatter.format(slotDateTime(slot))}';

String? sharedRecapLine(BookingDraft draft) {
  final slot = draft.sharedSlot;
  return slot == null ? null : slotRecapLabel(slot);
}

String scheduleRecapLine(BookingDraft draft, DateTime? sharedDateFallback) {
  if (draft.scheduleMode == ScheduleMode.split) return splitRecapLine(draft);
  final recap = sharedRecapLine(draft);
  if (recap != null) return recap;
  return sharedDateFallback != null
      ? DateFormatter.format(sharedDateFallback)
      : '';
}

String splitRecapLine(BookingDraft draft) {
  final total = draft.selectedMotorIds.length;
  final done = draft.selectedMotorIds
      .where((id) => draft.unitSlots.containsKey(id))
      .length;
  return '$done dari $total motor terjadwal';
}

String? scheduleReasonLine(BookingDraft draft, Map<String, Motor> motorsById) {
  if (draft.scheduleMode == ScheduleMode.split) {
    for (final id in draft.selectedMotorIds) {
      if (!draft.unitSlots.containsKey(id)) {
        return 'Pilih jam untuk ${motorsById[id]?.nickname ?? 'motor ini'}';
      }
    }
    return null;
  }
  return draft.sharedSlot == null ? 'Pilih jam kedatangan' : null;
}

bool canContinueSchedule(BookingDraft draft) {
  if (draft.scheduleMode == ScheduleMode.split) {
    return draft.selectedMotorIds.isNotEmpty &&
        draft.selectedMotorIds.every((id) => draft.unitSlots.containsKey(id));
  }
  return draft.sharedSlot != null;
}
