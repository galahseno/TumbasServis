import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/notification/data/di/notification_data_module.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import 'fake_booking_repository.dart';
import 'fake_catalog_repository.dart';
import 'fake_garage_repository.dart';
import 'fake_notification_repository.dart';
import 'fake_tracking_repository.dart';
import 'fake_workshop_repository.dart';

// ignore: strict_top_level_inference
homeScreenFakeOverrides() {
  final bookingRepository = FakeBookingRepository()
    ..bookingsResult = Result.ok([
      Booking(
        id: 'demo_seed_booking',
        code: DemoContentSeeder.canonicalBookingCode,
        userId: 'u1',
        workshopId: 'ws_001',
        units: const [],
        scheduleMode: ScheduleMode.shared,
        status: BookingStatus.berlangsung,
        subtotal: 0,
        discount: 0,
        total: 0,
        createdAt: DateTime(2026, 9, 20),
      ),
    ])
    ..getBookingResult = Result.error(Exception('unused in router tests'))
    ..currentDraftResult = const Result.ok(null)
    ..createDraftResult = Result.ok(
      BookingDraft(
        id: 'demo_seed_draft',
        selectedMotorIds: const [],
        unitConfigs: const {},
        scheduleMode: ScheduleMode.shared,
        unitSlots: const {},
        createdAt: DateTime(2026, 9, 20),
        expiresAt: DateTime(2099),
      ),
    );

  return [
    bookingRepositoryProvider.overrideWithValue(bookingRepository),
    garageRepositoryProvider.overrideWithValue(FakeGarageRepository()),
    catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
    workshopRepositoryProvider.overrideWithValue(FakeWorkshopRepository()),
    notificationRepositoryProvider.overrideWithValue(
      FakeNotificationRepository(),
    ),
    trackingRepositoryProvider.overrideWithValue(FakeTrackingRepository()),
  ];
}
