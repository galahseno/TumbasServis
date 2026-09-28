import 'package:tumbas_servis/booking/data/mapper/time_slot_mapper.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';

extension BookingDraftJsonX on Map<String, dynamic> {
  BookingDraft toBookingDraft() => BookingDraft(
    id: this['id'] as String,
    selectedMotorIds: (this['selected_motor_ids'] as List<dynamic>)
        .cast<String>(),
    unitConfigs: (this['unit_configs'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, _unitConfigFromJson(v as Map<String, dynamic>)),
    ),
    workshopId: this['workshop_id'] as String?,
    scheduleMode: ScheduleModeX.fromString(this['schedule_mode'] as String?),
    sharedSlot: this['shared_slot'] == null
        ? null
        : (this['shared_slot'] as Map<String, dynamic>).toTimeSlot(),
    unitSlots: (this['unit_slots'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, (v as Map<String, dynamic>).toTimeSlot()),
    ),
    voucherId: this['voucher_id'] as String?,
    createdAt: DateTime.parse(this['created_at'] as String),
    expiresAt: DateTime.parse(this['expires_at'] as String),
  );
}

extension BookingDraftJsonWriterX on BookingDraft {
  Map<String, dynamic> toDraftJson() => {
    'id': id,
    'selected_motor_ids': selectedMotorIds,
    'unit_configs': unitConfigs.map(
      (k, v) => MapEntry(k, _unitConfigToJson(v)),
    ),
    'workshop_id': workshopId,
    'schedule_mode': scheduleMode.name,
    'shared_slot': sharedSlot?.toTimeSlotJson(),
    'unit_slots': unitSlots.map((k, v) => MapEntry(k, v.toTimeSlotJson())),
    'voucher_id': voucherId,
    'created_at': createdAt.toIso8601String(),
    'expires_at': expiresAt.toIso8601String(),
  };
}

UnitConfig _unitConfigFromJson(Map<String, dynamic> json) => UnitConfig(
  serviceIds: (json['service_ids'] as List<dynamic>).cast<String>(),
  partIds: (json['part_ids'] as List<dynamic>).cast<String>(),
  complaintNote: json['complaint_note'] as String?,
);

Map<String, dynamic> _unitConfigToJson(UnitConfig config) => {
  'service_ids': config.serviceIds,
  'part_ids': config.partIds,
  if (config.complaintNote != null) 'complaint_note': config.complaintNote,
};
