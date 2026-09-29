// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/repository/booking/booking_repository.dart';
import 'package:tumbas_servis/core/domain/repository/tracking/tracking_repository.dart';

class DemoContentSeeder {
  const DemoContentSeeder({
    required BookingRepository bookingRepository,
    required TrackingRepository trackingRepository,
  }) : _bookingRepository = bookingRepository,
       _trackingRepository = trackingRepository;

  final BookingRepository _bookingRepository;
  final TrackingRepository _trackingRepository;

  static const canonicalBookingCode = 'TS-260929-0417';
  static const draftMotorId = 'motor_004';

  Future<void> seedIfNeeded() async {
    final bookingsResult = await _bookingRepository.getBookings();
    if (bookingsResult is! Ok<List<Booking>>) return;

    final alreadySeeded = bookingsResult.value.any(
      (b) => b.code == canonicalBookingCode,
    );
    if (alreadySeeded) return;

    await _seedActiveBooking();
    await _seedDraft();
  }

  Future<void> _seedActiveBooking() async {
    final confirmResult = await _bookingRepository.confirmBooking(
      BookingDraft(
        id: 'demo_seed_draft',
        selectedMotorIds: const ['motor_001', 'motor_002', 'motor_003'],
        unitConfigs: const {
          'motor_001': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
          'motor_002': UnitConfig(
            serviceIds: ['svc_berkala'],
            partIds: ['part_oli_mpx1'],
          ),
          'motor_003': UnitConfig(
            serviceIds: ['svc_berkala'],
            partIds: ['part_oli_mpx2', 'part_kampas_matic'],
          ),
        },
        workshopId: 'ws_001',
        scheduleMode: ScheduleMode.shared,
        sharedSlot: TimeSlot(
          date: DateTime(2026, 9, 29),
          hour: 9,
          capacity: 5,
          booked: 1,
        ),
        unitSlots: const {},
        voucherId: 'voucher_diskon10',
        createdAt: DateTime(2026, 9, 20),
        expiresAt: DateTime(2099),
      ),
    );
    if (confirmResult is! Ok<Booking>) return;
    final booking = confirmResult.value;

    await _advance(booking.id, '-A', 3); // terjadwal -> dikerjakan
    await _advance(booking.id, '-B', 3); // terjadwal -> dikerjakan
    await _advance(booking.id, '-C', 2); // terjadwal -> diperiksa
  }

  Future<void> _advance(String bookingId, String unitCode, int steps) async {
    for (var i = 0; i < steps; i++) {
      await _trackingRepository.advanceUnitStatus(
        bookingId: bookingId,
        unitCode: unitCode,
      );
    }
  }

  Future<void> _seedDraft() async {
    final bookingsResult = await _bookingRepository.getBookings();
    if (bookingsResult is Ok<List<Booking>>) {
      final inService = bookingsResult.value.any(
        (b) => b.units.any(
          (u) => u.motorId == draftMotorId && !u.status.isTerminal,
        ),
      );
      if (inService) return;
    }

    final currentResult = await _bookingRepository.getCurrentDraft();
    if (currentResult is Ok<BookingDraft?> && currentResult.value != null) {
      return;
    }

    final createResult = await _bookingRepository.createDraft();
    if (createResult is! Ok<BookingDraft>) return;
    final draft = createResult.value;
    if (draft.selectedMotorIds.isNotEmpty) return;

    await _bookingRepository.updateDraft(
      draft.copyWith(
        selectedMotorIds: const [draftMotorId],
        unitConfigs: const {
          draftMotorId: UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
        },
      ),
    );
  }
}
