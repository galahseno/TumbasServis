import 'package:tumbas_servis/booking/data/mapper/time_slot_mapper.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';

extension BookingJsonX on Map<String, dynamic> {
  Booking toBooking() => Booking(
    id: this['id'] as String,
    code: this['code'] as String,
    userId: this['user_id'] as String,
    workshopId: this['workshop_id'] as String,
    units: (this['units'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_bookingUnitFromJson)
        .toList(),
    scheduleMode: ScheduleModeX.fromString(this['schedule_mode'] as String?),
    sharedSlot: this['shared_slot'] == null
        ? null
        : (this['shared_slot'] as Map<String, dynamic>).toTimeSlot(),
    unitSlots: this['unit_slots'] == null
        ? null
        : (this['unit_slots'] as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, (v as Map<String, dynamic>).toTimeSlot()),
          ),
    status: BookingStatusX.fromString(this['status'] as String?),
    voucherId: this['voucher_id'] as String?,
    subtotal: this['subtotal'] as int,
    discount: this['discount'] as int,
    total: this['total'] as int,
    createdAt: DateTime.parse(this['created_at'] as String),
    completedAt: this['completed_at'] == null
        ? null
        : DateTime.parse(this['completed_at'] as String),
  );
}

extension BookingJsonWriterX on Booking {
  Map<String, dynamic> toBookingJson() => {
    'id': id,
    'code': code,
    'user_id': userId,
    'workshop_id': workshopId,
    'units': units.map(_bookingUnitToJson).toList(),
    'schedule_mode': scheduleMode.name,
    'shared_slot': sharedSlot?.toTimeSlotJson(),
    'unit_slots': unitSlots?.map((k, v) => MapEntry(k, v.toTimeSlotJson())),
    'status': status.name,
    'voucher_id': voucherId,
    'subtotal': subtotal,
    'discount': discount,
    'total': total,
    'created_at': createdAt.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
  };
}

BookingUnit _bookingUnitFromJson(Map<String, dynamic> json) => BookingUnit(
  unitCode: json['unit_code'] as String,
  motorId: json['motor_id'] as String,
  motorSnapshot: _motorSnapshotFromJson(
    json['motor_snapshot'] as Map<String, dynamic>,
  ),
  serviceIds: (json['service_ids'] as List<dynamic>).cast<String>(),
  partIds: (json['part_ids'] as List<dynamic>).cast<String>(),
  complaintNote: json['complaint_note'] as String?,
  status: UnitStatusX.fromString(json['status'] as String?),
  statusHistory: (json['status_history'] as List<dynamic>)
      .cast<Map<String, dynamic>>()
      .map(_statusEventFromJson)
      .toList(),
  mechanicId: json['mechanic_id'] as String?,
  subtotal: json['subtotal'] as int,
  durationMin: json['duration_min'] as int,
);

Map<String, dynamic> _bookingUnitToJson(BookingUnit unit) => {
  'unit_code': unit.unitCode,
  'motor_id': unit.motorId,
  'motor_snapshot': _motorSnapshotToJson(unit.motorSnapshot),
  'service_ids': unit.serviceIds,
  'part_ids': unit.partIds,
  if (unit.complaintNote != null) 'complaint_note': unit.complaintNote,
  'status': unit.status.name,
  'status_history': unit.statusHistory.map(_statusEventToJson).toList(),
  if (unit.mechanicId != null) 'mechanic_id': unit.mechanicId,
  'subtotal': unit.subtotal,
  'duration_min': unit.durationMin,
};

StatusEvent _statusEventFromJson(Map<String, dynamic> json) => StatusEvent(
  status: UnitStatusX.fromString(json['status'] as String?),
  timestamp: DateTime.parse(json['timestamp'] as String),
  note: json['note'] as String?,
);

Map<String, dynamic> _statusEventToJson(StatusEvent event) => {
  'status': event.status.name,
  'timestamp': event.timestamp.toIso8601String(),
  if (event.note != null) 'note': event.note,
};

Motor _motorSnapshotFromJson(Map<String, dynamic> json) => Motor(
  id: json['id'] as String,
  ownerId: json['owner_id'] as String,
  nickname: json['nickname'] as String,
  plateNumber: json['plate_number'] as String,
  year: json['year'] as int?,
  photoUrl: json['photo_url'] as String?,
  modelId: json['model_id'] as String,
);

Map<String, dynamic> _motorSnapshotToJson(Motor motor) => {
  'id': motor.id,
  'owner_id': motor.ownerId,
  'nickname': motor.nickname,
  'plate_number': motor.plateNumber,
  'year': motor.year,
  'photo_url': motor.photoUrl,
  'model_id': motor.modelId,
};
