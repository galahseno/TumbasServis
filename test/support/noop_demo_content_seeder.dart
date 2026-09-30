import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';

import 'fake_booking_repository.dart';
import 'fake_tracking_repository.dart';

class NoopDemoContentSeeder extends DemoContentSeeder {
  NoopDemoContentSeeder()
    : super(
        bookingRepository: FakeBookingRepository(),
        trackingRepository: FakeTrackingRepository(),
      );

  @override
  Future<void> seedIfNeeded({SeedProgressCallback? onProgress}) async {}
}
