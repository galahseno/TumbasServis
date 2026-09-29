import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';

Motor motorFixture(
  String id, {
  String nickname = 'Beat 110',
  String plate = 'AB 5678 ZZ',
  String modelId = 'model_beat',
  int? year = 2021,
}) => Motor(
  id: id,
  ownerId: 'user_001',
  nickname: nickname,
  plateNumber: plate,
  modelId: modelId,
  year: year,
);

BookingUnit unitFixture(
  String code,
  String motorId,
  UnitStatus status, {
  List<String> serviceIds = const ['svc_berkala'],
  int subtotal = 85000,
}) => BookingUnit(
  unitCode: code,
  motorId: motorId,
  motorSnapshot: motorFixture(motorId),
  serviceIds: serviceIds,
  partIds: const [],
  status: status,
  statusHistory: [
    StatusEvent(status: status, timestamp: DateTime(2026, 9, 29)),
  ],
  subtotal: subtotal,
  durationMin: 60,
);

Booking bookingFixture(
  String id,
  List<BookingUnit> units, {
  DateTime? createdAt,
  DateTime? completedAt,
}) => Booking(
  id: id,
  code: id,
  userId: 'user_001',
  workshopId: 'ws_001',
  units: units,
  scheduleMode: ScheduleMode.shared,
  status: BookingStatus.berlangsung,
  subtotal: 0,
  discount: 0,
  total: 0,
  createdAt: createdAt ?? DateTime(2026, 9, 20),
  completedAt: completedAt,
);
