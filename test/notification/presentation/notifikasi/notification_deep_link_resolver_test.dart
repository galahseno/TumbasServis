import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_args.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/notification/presentation/utils/notification_deep_link_resolver.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/tracking_fixtures.dart';

void main() {
  late FakeBookingRepository bookingRepository;
  late NotificationDeepLinkResolver resolver;

  setUp(() {
    bookingRepository = FakeBookingRepository();
    resolver = NotificationDeepLinkResolver(
      bookingRepository: bookingRepository,
    );
  });

  test('null, empty and unknown links have no target', () async {
    expect(await resolver.resolve(null), isNull);
    expect(await resolver.resolve(''), isNull);
    expect(await resolver.resolve('/somewhere/else'), isNull);
    expect(await resolver.resolve('/bookings'), isNull);
  });

  test('real unit path -> S21 (status notification)', () async {
    final target = await resolver.resolve('/bookings/bk_1/unit/-B');

    expect(target!.location, Routes.bookingUnitDetail('bk_1', '-B'));
    expect(target.replaceStack, isFalse);
  });

  test('real booking path -> S20 (booking confirmation)', () async {
    final target = await resolver.resolve('/bookings/bk_1');

    expect(target!.location, Routes.bookingDetail('bk_1'));
  });

  test('legacy /tracking/:id/:code -> S21', () async {
    final target = await resolver.resolve('/tracking/bk_1/-A');

    expect(target!.location, Routes.bookingUnitDetail('bk_1', '-A'));
  });

  test(
    'legacy /booking/:id -> S20, but flow routes are not bookings',
    () async {
      expect(
        (await resolver.resolve('/booking/bk_1'))!.location,
        Routes.bookingDetail('bk_1'),
      );
      expect(await resolver.resolve('/booking/summary'), isNull);
      expect(await resolver.resolve('/booking/schedule'), isNull);
    },
  );

  test('invoice ready -> S23', () async {
    final target = await resolver.resolve('/invoice/bk_seed_001');

    expect(target!.location, Routes.invoice('bk_seed_001'));
  });

  test('reminder -> S10 with the motor preselected', () async {
    final target = await resolver.resolve(
      '/booking/vehicles?motorId=motor_004',
    );

    expect(target!.location, Routes.bookingVehicles);
    final args = target.extra! as PilihMotorArgs;
    expect(args.motorIds, ['motor_004']);
    expect(args.voucherId, isNull);
  });

  test(
    'promo -> S10 with the voucher carried (legacy select-motor too)',
    () async {
      for (final link in [
        '/booking/vehicles?voucherId=voucher_hemat25',
        '/booking/select-motor?voucherId=voucher_hemat25',
      ]) {
        final target = await resolver.resolve(link);
        expect(target!.location, Routes.bookingVehicles, reason: link);
        final args = target.extra! as PilihMotorArgs;
        expect(args.voucherId, 'voucher_hemat25', reason: link);
        expect(args.motorIds, isEmpty, reason: link);
      }
    },
  );

  group('seed alias bk_active_0417', () {
    test('resolves to the booking with the canonical code', () async {
      final canonical = trackedBooking('bk_real_123', [
        trackedUnit('-A', UnitStatus.dikerjakan),
      ]).copyWith(code: DemoContentSeeder.canonicalBookingCode);
      bookingRepository.bookingsResult = Result.ok([
        trackedBooking('bk_other', [trackedUnit('-A', UnitStatus.dikerjakan)]),
        canonical,
      ]);

      final unit = await resolver.resolve('/bookings/bk_active_0417/unit/-C');
      final booking = await resolver.resolve('/bookings/bk_active_0417');

      expect(unit!.location, Routes.bookingUnitDetail('bk_real_123', '-C'));
      expect(booking!.location, Routes.bookingDetail('bk_real_123'));
    });

    test('missing booking falls back to Riwayat with a message', () async {
      bookingRepository.bookingsResult = const Result.ok([]);

      final target = await resolver.resolve('/bookings/bk_active_0417');

      expect(target!.location, Routes.bookings);
      expect(target.replaceStack, isTrue);
      expect(target.message, 'Booking tidak ditemukan.');
    });

    test('repository error falls back too', () async {
      bookingRepository.bookingsResult = Result.error(Exception('boom'));

      final target = await resolver.resolve('/bookings/bk_active_0417');

      expect(target!.location, Routes.bookings);
    });
  });
}
