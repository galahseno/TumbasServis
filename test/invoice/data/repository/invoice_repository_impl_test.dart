import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/auth/data/repository/session_repository_impl.dart';
import 'package:tumbas_servis/booking/data/repository/booking_repository_impl.dart';
import 'package:tumbas_servis/catalog/data/repository/catalog_repository_impl.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/repository/garage_repository_impl.dart';
import 'package:tumbas_servis/invoice/data/repository/invoice_repository_impl.dart';

import '../../../support/fake_clock.dart';
import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late LocalStore localStore;
  late FakeClock clock;
  late InvoiceRepositoryImpl repository;

  const repeatedBookingId = 'bk_repeated_ids_test';

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('invoice_repo_test');
    localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    clock = FakeClock(DateTime(2026, 9, 29, 9));

    final sessionRepository = SessionRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
      demoModeController: DemoModeController(),
    );
    await sessionRepository.verifyOtp('123456');

    final bookingRepository = BookingRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
      clock: clock,
      catalogRepository: CatalogRepositoryImpl(
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: FakeLatencySimulator(),
      ),
      garageRepository: GarageRepositoryImpl(
        localStore: localStore,
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: FakeLatencySimulator(),
        hasActiveBooking: (_) async => false,
      ),
      sessionRepository: sessionRepository,
    );

    repository = InvoiceRepositoryImpl(
      localStore: localStore,
      latencySimulator: FakeLatencySimulator(),
      clock: clock,
      bookingRepository: bookingRepository,
      catalogRepository: CatalogRepositoryImpl(
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: FakeLatencySimulator(),
      ),
    );

    // Force the booking seed to load so bk_seed_001/002/004 exist, then add
    // one synthetic completed booking with repeated service/part ids.
    await bookingRepository.getBookings();
    await localStore.put('bookings', repeatedBookingId, {
      'id': repeatedBookingId,
      'code': 'TS-260929-9999',
      'user_id': 'user_001',
      'workshop_id': 'ws_001',
      'units': [
        {
          'unit_code': '-A',
          'motor_id': 'motor_001',
          'motor_snapshot': {
            'id': 'motor_001',
            'owner_id': 'user_001',
            'nickname': 'Vario 125',
            'plate_number': 'AB 1234 XY',
            'year': 2022,
            'model_id': 'model_vario125',
          },
          'service_ids': ['svc_berkala', 'svc_oli', 'svc_oli'],
          'part_ids': ['part_oli_mpx1', 'part_oli_mpx1'],
          'status': 'selesai',
          'status_history': [
            {
              'status': 'selesai',
              'timestamp': DateTime(2026, 9, 29, 9).toIso8601String(),
            },
          ],
          'subtotal': 271000,
          'duration_min': 90,
        },
      ],
      'schedule_mode': 'shared',
      'shared_slot': {
        'date': DateTime(2026, 9, 29).toIso8601String(),
        'hour': 9,
        'capacity': 5,
        'booked': 1,
      },
      'status': 'selesai',
      'subtotal': 271000,
      'discount': 0,
      'total': 271000,
      'created_at': DateTime(2026, 9, 29, 8).toIso8601String(),
      'completed_at': DateTime(2026, 9, 29, 9).toIso8601String(),
    });
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test(
    'getInvoice derives per-unit line items from the completed seed booking',
    () async {
      final result = await repository.getInvoice('bk_seed_001');
      expect(result, isA<Ok<Invoice>>());
      final invoice = (result as Ok<Invoice>).value;

      expect(invoice.lines, hasLength(3));
      expect(
        invoice.lines.map((l) => l.label),
        containsAll(['Servis Berkala', 'Ganti Oli', 'AHM Oli MPX1']),
      );
      final unitSum = invoice.lines.fold<int>(
        0,
        (sum, l) => sum + l.qty * l.price,
      );
      expect(unitSum, invoice.subtotal);
      expect(invoice.subtotal, 178000);
      expect(invoice.total, invoice.subtotal - invoice.discount);
      expect(invoice.isPaid, isFalse);
    },
  );

  test(
    'a repeated service/part id collapses into one line with qty > 1',
    () async {
      final result = await repository.getInvoice(repeatedBookingId);
      expect(result, isA<Ok<Invoice>>());
      final invoice = (result as Ok<Invoice>).value;

      expect(invoice.lines, hasLength(3));
      final oli = invoice.lines.firstWhere((l) => l.label == 'Ganti Oli');
      expect(oli.qty, 2);
      final part = invoice.lines.firstWhere((l) => l.label == 'AHM Oli MPX1');
      expect(part.qty, 2);
      expect(
        invoice.lines.fold<int>(0, (sum, l) => sum + l.qty * l.price),
        invoice.subtotal,
      );
    },
  );

  test('refuses a booking that has not reached selesai', () async {
    final result = await repository.getInvoice('bk_seed_004');
    expect(result, isA<Error<Invoice>>());
  });

  test(
    'getInvoice called twice returns the same materialized invoice',
    () async {
      final first = (await repository.getInvoice('bk_seed_001')) as Ok<Invoice>;
      clock.setNow(clock.now().add(const Duration(days: 1)));
      final second =
          (await repository.getInvoice('bk_seed_001')) as Ok<Invoice>;
      expect(second.value.issuedAt, first.value.issuedAt);
    },
  );

  group('markPaid', () {
    test('flips isPaid/paidAt and is idempotent on a second call', () async {
      final first = await repository.markPaid('bk_seed_001');
      expect(first, isA<Ok<void>>());

      final invoice =
          ((await repository.getInvoice('bk_seed_001')) as Ok<Invoice>).value;
      expect(invoice.isPaid, isTrue);
      final paidAt = invoice.paidAt;
      expect(paidAt, isNotNull);

      clock.setNow(clock.now().add(const Duration(hours: 1)));
      final second = await repository.markPaid('bk_seed_001');
      expect(second, isA<Ok<void>>());
      final unchanged =
          ((await repository.getInvoice('bk_seed_001')) as Ok<Invoice>).value;
      expect(unchanged.paidAt, paidAt);
    });

    test(
      'propagates the same error as getInvoice for a non-selesai booking',
      () async {
        final result = await repository.markPaid('bk_seed_004');
        expect(result, isA<Error<void>>());
      },
    );
  });
}
