import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/review/presentation/di/review_presentation_module.dart';
import 'package:tumbas_servis/review/presentation/ulasan/state/ulasan_state.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_clock.dart';
import '../../../support/fake_invoice_repository.dart';
import '../../../support/fake_review_repository.dart';
import '../../../support/fake_workshop_repository.dart';
import '../../../support/invoice_review_fixtures.dart';
import '../../../support/tracking_fixtures.dart';

void main() {
  late FakeBookingRepository bookingRepository;
  late FakeInvoiceRepository invoiceRepository;
  late FakeReviewRepository reviewRepository;
  late ProviderContainer container;

  const bookingId = 'fin1';
  final provider = ulasanViewModelProvider(bookingId);
  final now = DateTime(2026, 9, 29, 11, 31);

  setUp(() {
    bookingRepository = FakeBookingRepository()
      ..getBookingResult = Result.ok(canonicalFinishedBooking());
    invoiceRepository = FakeInvoiceRepository()..paid = true;
    reviewRepository = FakeReviewRepository();
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        invoiceRepositoryProvider.overrideWithValue(invoiceRepository),
        reviewRepositoryProvider.overrideWithValue(reviewRepository),
        workshopRepositoryProvider.overrideWithValue(
          FakeWorkshopRepository()
            ..workshopResult = const Result.ok(workshopFixture)
            ..mechanicsResult = const Result.ok(mechanicFixtures),
        ),
        clockProvider.overrideWithValue(FakeClock(now)),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<UlasanState> settle() async {
    container.listen(provider, (_, _) {});
    for (var i = 0; i < 50; i++) {
      if (!container.read(provider).isLoading) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return container.read(provider);
  }

  test(
    'mechanic section shows for ≥2 distinct mechanics, grouped by mechanic',
    () async {
      final state = await settle();

      expect(state.showMechanicSection, isTrue);
      expect(state.mechanics.map((m) => m.name), ['Pak Anto', 'Mas Rudi']);
      expect(state.mechanics.first.unitsLabel, 'Vario 125 + PCX 160');
      expect(state.mechanics.last.unitsLabel, 'Beat 110');
      expect(state.workshopName, 'Bengkel Jaya Motor');
      expect(state.blockedUnpaid, isFalse);
      expect(state.isSubmitted, isFalse);
    },
  );

  test('mechanic section is hidden for a single mechanic', () async {
    bookingRepository.getBookingResult = Result.ok(
      singleMechanicFinishedBooking(),
    );

    final state = await settle();

    expect(state.mechanics, hasLength(1));
    expect(state.showMechanicSection, isFalse);
  });

  test(
    'submit is validated on submit: no stars → error, nothing sent',
    () async {
      await settle();

      final ok = await container.read(provider.notifier).submit();
      final state = container.read(provider);

      expect(ok, isFalse);
      expect(state.ratingError, isTrue);
      expect(state.isSubmitting, isFalse);
      expect(reviewRepository.submitCalls, isEmpty);

      container.read(provider.notifier).setWorkshopRating(4);
      expect(container.read(provider).ratingError, isFalse);
    },
  );

  test('submit saves the review and switches to the read-only recap', () async {
    await settle();
    final notifier = container.read(provider.notifier);
    notifier.setWorkshopRating(5);
    notifier.setComment('  Cepat dan rapi.  ');
    notifier.setMechanicRating('mech_001', 5);
    notifier.setMechanicRating('mech_002', 4);

    final ok = await notifier.submit();
    final state = container.read(provider);

    expect(ok, isTrue);
    expect(state.isSubmitted, isTrue);
    final saved = reviewRepository.submitCalls.single;
    expect(saved.bookingId, bookingId);
    expect(saved.workshopRating, 5);
    expect(saved.workshopComment, 'Cepat dan rapi.');
    expect(saved.mechanicRatings, {'mech_001': 5, 'mech_002': 4});
    expect(saved.createdAt, now);
    expect(state.submitted, saved);
  });

  test(
    'mechanic ratings are optional and dropped for a single mechanic',
    () async {
      bookingRepository.getBookingResult = Result.ok(
        singleMechanicFinishedBooking(),
      );
      await settle();
      final notifier = container.read(provider.notifier);
      notifier.setWorkshopRating(3);
      notifier.setMechanicRating('mech_001', 5); // stale, section hidden

      await notifier.submit();

      final saved = reviewRepository.submitCalls.single;
      expect(saved.mechanicRatings, isEmpty);
      expect(saved.workshopComment, isNull);
    },
  );

  test('tapping a mechanic rating again clears it', () async {
    await settle();
    final notifier = container.read(provider.notifier);

    notifier.setMechanicRating('mech_001', 4);
    expect(container.read(provider).mechanicRatings, {'mech_001': 4});

    notifier.setMechanicRating('mech_001', 4);
    expect(container.read(provider).mechanicRatings, isEmpty);
  });

  test('comment is clamped to 300 characters', () async {
    await settle();

    container.read(provider.notifier).setComment('x' * 350);

    expect(
      container.read(provider).comment.length,
      Review.workshopCommentMaxLength,
    );
  });

  test('a failed submit keeps the form so the user can retry', () async {
    await settle();
    final notifier = container.read(provider.notifier);
    notifier.setWorkshopRating(4);
    notifier.setComment('Bagus');
    reviewRepository.failSubmit = true;

    final ok = await notifier.submit();
    final state = container.read(provider);

    expect(ok, isFalse);
    expect(state.isSubmitted, isFalse);
    expect(state.isSubmitting, isFalse);
    expect(state.workshopRating, 4);
    expect(state.comment, 'Bagus');

    reviewRepository.failSubmit = false;
    expect(await notifier.submit(), isTrue);
  });

  test('an unpaid invoice blocks the form (defense-in-depth)', () async {
    invoiceRepository.paid = false;

    final state = await settle();

    expect(state.blockedUnpaid, isTrue);
    expect(await container.read(provider.notifier).submit(), isFalse);
    expect(reviewRepository.submitCalls, isEmpty);
  });

  test('an existing review opens straight into the recap', () async {
    reviewRepository.review = Review(
      bookingId: bookingId,
      workshopRating: 5,
      workshopComment: 'Mantap',
      mechanicRatings: const {'mech_001': 5},
      createdAt: now,
    );

    final state = await settle();

    expect(state.isSubmitted, isTrue);
    expect(state.blockedUnpaid, isFalse);
    expect(state.submitted!.workshopComment, 'Mantap');
  });

  test('booking/invoice failure → error state', () async {
    invoiceRepository.fail = true;

    final state = await settle();

    expect(state.hasError, isTrue);
  });

  test('unknown mechanic ids are ignored', () async {
    final booking = canonicalFinishedBooking();
    bookingRepository.getBookingResult = Result.ok(
      booking.copyWith(
        units: [
          for (final u in booking.units) u.copyWith(mechanicId: 'mech_zzz'),
        ],
      ),
    );

    final state = await settle();

    expect(state.mechanics, isEmpty);
    expect(state.showMechanicSection, isFalse);
  });
}
