import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/notification/data/di/notification_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_clock.dart';
import '../../../support/fake_garage_repository.dart';
import '../../../support/fake_notification_repository.dart';
import '../../../support/fake_session_repository.dart';
import '../../../support/fake_workshop_repository.dart';
import '../../../support/noop_demo_content_seeder.dart';

Motor _motor(String id, String nickname) => Motor(
  id: id,
  ownerId: 'user_001',
  nickname: nickname,
  plateNumber: 'AB 0000 XY',
  modelId: 'model_x',
);

BookingUnit _unit(String code, String motorId, UnitStatus status) =>
    BookingUnit(
      unitCode: code,
      motorId: motorId,
      motorSnapshot: _motor(motorId, motorId),
      serviceIds: const ['svc_berkala'],
      partIds: const [],
      status: status,
      statusHistory: [
        StatusEvent(status: status, timestamp: DateTime(2026, 9, 29)),
      ],
      subtotal: 85000,
      durationMin: 60,
    );

Booking _canonicalBooking() => Booking(
  id: 'bk_1',
  code: 'TS-260929-0417',
  userId: 'user_001',
  workshopId: 'ws_001',
  units: [
    _unit('-A', 'motor_001', UnitStatus.dikerjakan),
    _unit('-B', 'motor_002', UnitStatus.dikerjakan),
    _unit('-C', 'motor_003', UnitStatus.diperiksa),
  ],
  scheduleMode: ScheduleMode.shared,
  sharedSlot: TimeSlot(
    date: DateTime(2026, 9, 29),
    hour: 9,
    capacity: 5,
    booked: 3,
  ),
  status: BookingStatus.berlangsung,
  subtotal: 428000,
  discount: 42800,
  total: 385200,
  createdAt: DateTime(2026, 9, 20),
);

void main() {
  late FakeSessionRepository sessionRepository;
  late FakeGarageRepository garageRepository;
  late FakeCatalogRepository catalogRepository;
  late FakeBookingRepository bookingRepository;
  late FakeNotificationRepository notificationRepository;
  late FakeWorkshopRepository workshopRepository;
  late FakeClock clock;
  late ProviderContainer container;

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  setUp(() {
    sessionRepository = FakeSessionRepository()
      ..currentUserResult = Result.ok(
        User(id: 'user_001', name: 'Galah', phone: '0812'),
      );
    garageRepository = FakeGarageRepository();
    catalogRepository = FakeCatalogRepository();
    bookingRepository = FakeBookingRepository();
    notificationRepository = FakeNotificationRepository();
    workshopRepository = FakeWorkshopRepository()
      ..workshopsResult = Result.ok([
        Workshop(
          id: 'ws_001',
          name: 'Bengkel Jaya Motor',
          rating: 4.8,
          reviewCount: 120,
          distanceKm: 1.2,
          address: 'Jl. Merdeka 1',
          openTime: 8,
          closeTime: 17,
          bayCount: 3,
          staticMapAssetPath: 'assets/images/maps/ws_001_map.png',
          serviceIds: const ['svc_berkala'],
        ),
      ]);
    clock = FakeClock(DateTime(2026, 9, 29, 9, 0));

    container = ProviderContainer(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(sessionRepository),
        garageRepositoryProvider.overrideWithValue(garageRepository),
        catalogRepositoryProvider.overrideWithValue(catalogRepository),
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        notificationRepositoryProvider.overrideWithValue(
          notificationRepository,
        ),
        workshopRepositoryProvider.overrideWithValue(workshopRepository),
        clockProvider.overrideWithValue(clock),
        demoContentSeederProvider.overrideWithValue(NoopDemoContentSeeder()),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<void> waitForLoad() async {
    for (var i = 0; i < 100; i++) {
      if (!container.read(homeViewModelProvider).isLoading) return;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    throw StateError('HomeViewModel never finished loading');
  }

  test('empty state: no active booking, no draft', () async {
    await waitForLoad();
    final state = container.read(homeViewModelProvider);

    expect(state.isEmpty, isTrue);
    expect(state.activeBookings, isEmpty);
    expect(state.draft, isNull);
  });

  test('populated state derives the majority status label + caption from the '
      'canonical 3-unit booking', () async {
    bookingRepository.bookingsResult = Result.ok([_canonicalBooking()]);
    await waitForLoad();
    final state = container.read(homeViewModelProvider);

    expect(state.activeBookings, hasLength(1));
    final display = state.activeBookings.first;
    expect(display.statusLabel, 'Dikerjakan');
    expect(display.statusCaption, '1 motor masih diperiksa');
    expect(display.scheduleLine, contains('Bengkel Jaya Motor'));
  });

  test('draft expiry warning switches under the 3h threshold', () async {
    final draft = BookingDraft(
      id: 'draft_1',
      selectedMotorIds: const ['motor_004'],
      unitConfigs: const {
        'motor_004': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
      },
      scheduleMode: ScheduleMode.shared,
      unitSlots: const {},
      createdAt: DateTime(2026, 9, 28, 9),
      expiresAt: DateTime(2026, 9, 29, 12),
    );
    bookingRepository.currentDraftResult = Result.ok(draft);

    clock.setNow(DateTime(2026, 9, 29, 9)); // 3h left -> not yet warning
    await waitForLoad();
    var display = container.read(homeViewModelProvider).draft;
    expect(display, isNotNull);
    expect(display!.expiringSoon, isFalse);
    expect(display.summaryLine, contains('Langkah 2 dari 4'));

    clock.setNow(DateTime(2026, 9, 29, 10)); // 2h left -> warning
    await container.read(homeViewModelProvider.notifier).refresh();
    display = container.read(homeViewModelProvider).draft;
    expect(display!.expiringSoon, isTrue);
  });

  test('deleteDraft clears the draft via the repository', () async {
    final draft = BookingDraft(
      id: 'draft_1',
      selectedMotorIds: const ['motor_004'],
      unitConfigs: const {},
      scheduleMode: ScheduleMode.shared,
      unitSlots: const {},
      createdAt: DateTime(2026, 9, 28),
      expiresAt: DateTime(2026, 9, 29, 12),
    );
    bookingRepository.currentDraftResult = Result.ok(draft);
    await waitForLoad();

    await container.read(homeViewModelProvider.notifier).deleteDraft();

    expect(bookingRepository.draftDeleted, isTrue);
    expect(container.read(homeViewModelProvider).draft, isNull);
  });
}
