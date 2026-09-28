import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';

import 'fake_booking_repository.dart';
import 'fake_tracking_repository.dart';

/// A `DemoContentSeeder` that never mutates anything — for view-model
/// tests that already fully control their fake repositories' contents and
/// don't want the seeder's own `confirmBooking`/`advanceUnitStatus`
/// orchestration in the picture (that orchestration has its own coverage
/// via `booking_repository_impl_test.dart`'s underlying methods).
class NoopDemoContentSeeder extends DemoContentSeeder {
  NoopDemoContentSeeder()
    : super(
        bookingRepository: FakeBookingRepository(),
        trackingRepository: FakeTrackingRepository(),
      );

  @override
  Future<void> seedIfNeeded() async {}
}
