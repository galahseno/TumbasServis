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
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/garage/data/repository/garage_repository_impl.dart';
import 'package:tumbas_servis/invoice/data/repository/invoice_repository_impl.dart';
import 'package:tumbas_servis/review/data/repository/review_repository_impl.dart';

import '../../../support/fake_clock.dart';
import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late InvoiceRepositoryImpl invoiceRepository;
  late ReviewRepositoryImpl repository;

  const bookingId = 'bk_seed_001';

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('review_repo_test');
    final localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    final clock = FakeClock(DateTime(2026, 9, 29, 9));

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

    invoiceRepository = InvoiceRepositoryImpl(
      localStore: localStore,
      latencySimulator: FakeLatencySimulator(),
      clock: clock,
      bookingRepository: bookingRepository,
      catalogRepository: CatalogRepositoryImpl(
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: FakeLatencySimulator(),
      ),
    );

    repository = ReviewRepositoryImpl(
      localStore: localStore,
      latencySimulator: FakeLatencySimulator(),
      invoiceRepository: invoiceRepository,
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  Review review({
    Map<String, int> mechanicRatings = const {},
    String? workshopComment,
  }) => Review(
    bookingId: bookingId,
    workshopRating: 5,
    workshopComment: workshopComment,
    mechanicRatings: mechanicRatings,
    createdAt: DateTime(2026, 9, 29, 12),
  );

  test('submitReview is rejected while the invoice is unpaid', () async {
    await invoiceRepository.getInvoice(bookingId);
    final result = await repository.submitReview(review());
    expect(result, isA<Error<void>>());
  });

  test('submitReview succeeds after the invoice is paid, preserving '
      'mechanicRatings exactly as given', () async {
    await invoiceRepository.markPaid(bookingId);

    final withOneMechanic = review(mechanicRatings: {'mech_001': 4});
    final result = await repository.submitReview(withOneMechanic);
    expect(result, isA<Ok<void>>());

    final stored = await repository.getReview(bookingId);
    expect(stored, isA<Ok<Review?>>());
    final value = (stored as Ok<Review?>).value;
    expect(value, isNotNull);
    expect(value!.mechanicRatings, {'mech_001': 4});
  });

  test('submitReview accepts an empty mechanicRatings map without enforcing '
      'any minimum count', () async {
    await invoiceRepository.markPaid(bookingId);
    final result = await repository.submitReview(review());
    expect(result, isA<Ok<void>>());
  });

  test('submitReview rejects a workshop comment over 300 characters', () async {
    await invoiceRepository.markPaid(bookingId);
    final result = await repository.submitReview(
      review(workshopComment: 'x' * 301),
    );
    expect(result, isA<Error<void>>());
  });

  test(
    'resubmitting for the same booking overwrites the stored review',
    () async {
      await invoiceRepository.markPaid(bookingId);
      await repository.submitReview(review(mechanicRatings: {'mech_001': 3}));
      await repository.submitReview(review(mechanicRatings: {'mech_001': 5}));

      final value =
          ((await repository.getReview(bookingId)) as Ok<Review?>).value;
      expect(value!.mechanicRatings, {'mech_001': 5});
    },
  );

  test('getReview returns null for a booking with no review', () async {
    final result = await repository.getReview('bk_seed_002');
    expect(result, isA<Ok<Review?>>());
    expect((result as Ok<Review?>).value, isNull);
  });
}
