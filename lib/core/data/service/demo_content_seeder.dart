// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/repository/booking/booking_repository.dart';
import 'package:tumbas_servis/core/domain/repository/tracking/tracking_repository.dart';

typedef SeedProgressCallback = void Function(double fraction, String label);

class DemoContentSeeder {
  const DemoContentSeeder({
    required BookingRepository bookingRepository,
    required TrackingRepository trackingRepository,
    DemoModeController? demoModeController,
  }) : _bookingRepository = bookingRepository,
       _trackingRepository = trackingRepository,
       _demoModeController = demoModeController;

  final BookingRepository _bookingRepository;
  final TrackingRepository _trackingRepository;
  final DemoModeController? _demoModeController;

  static const canonicalBookingCode = 'TS-260929-0417';
  static const draftMotorId = 'motor_004';

  static const _seedStepCount = 10;

  Future<void> seedIfNeeded({SeedProgressCallback? onProgress}) async {
    final bookingsResult = await _bookingRepository.getBookings();
    if (bookingsResult is! Ok<List<Booking>>) return;

    final alreadySeeded = bookingsResult.value.any(
      (b) => b.code == canonicalBookingCode,
    );
    if (alreadySeeded) return;

    var doneSteps = 0;
    void step() {
      doneSteps++;
      onProgress?.call(doneSteps / _seedStepCount, 'Menyiapkan data demo…');
    }

    onProgress?.call(0, 'Menyiapkan data demo…');
    _demoModeController?.beginSeeding();
    try {
      await _seedActiveBooking(step);
      await _seedDraft();
      step();
    } finally {
      _demoModeController?.endSeeding();
    }
  }

  Future<void> _seedActiveBooking(void Function() step) async {
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
    step();

    await _advance(booking.id, '-A', 3, step); // terjadwal -> dikerjakan
    await _advance(booking.id, '-B', 3, step); // terjadwal -> dikerjakan
    await _advance(booking.id, '-C', 2, step); // terjadwal -> diperiksa
  }

  Future<void> _advance(
    String bookingId,
    String unitCode,
    int steps,
    void Function() step,
  ) async {
    for (var i = 0; i < steps; i++) {
      await _trackingRepository.advanceUnitStatus(
        bookingId: bookingId,
        unitCode: unitCode,
      );
      step();
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
