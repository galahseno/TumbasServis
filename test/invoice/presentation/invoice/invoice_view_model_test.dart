import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/invoice/presentation/di/invoice_presentation_module.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/state/invoice_state.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
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
  final provider = invoiceViewModelProvider(bookingId);

  setUp(() {
    bookingRepository = FakeBookingRepository()
      ..getBookingResult = Result.ok(canonicalFinishedBooking());
    invoiceRepository = FakeInvoiceRepository()
      ..lines = canonicalInvoiceLines
      ..discount = 42800;
    reviewRepository = FakeReviewRepository();
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        invoiceRepositoryProvider.overrideWithValue(invoiceRepository),
        reviewRepositoryProvider.overrideWithValue(reviewRepository),
        workshopRepositoryProvider.overrideWithValue(
          FakeWorkshopRepository()
            ..workshopResult = const Result.ok(workshopFixture),
        ),
        catalogRepositoryProvider.overrideWithValue(
          FakeCatalogRepository()
            ..vouchersResult = Result.ok([voucherDiskon10]),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<InvoiceState> settle() async {
    container.listen(provider, (_, _) {});
    for (var i = 0; i < 50; i++) {
      final state = container.read(provider);
      if (!state.isLoading && !state.isMarking) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return container.read(provider);
  }

  test('loads the invoice with workshop, voucher code and totals', () async {
    final state = await settle();

    expect(state.isReady, isTrue);
    expect(state.workshopName, 'Bengkel Jaya Motor');
    expect(state.voucherCode, 'DISKON10');
    expect(state.invoice!.subtotal, 428000);
    expect(state.invoice!.discount, 42800);
    expect(state.invoice!.total, 385200);
    expect(state.isPaid, isFalse);
    expect(state.hasReview, isFalse);
  });

  test('no voucher on the booking → no voucher code', () async {
    bookingRepository.getBookingResult = Result.ok(
      canonicalFinishedBooking().copyWith(voucherId: null, discount: 0),
    );

    final state = await settle();

    expect(state.voucherCode, isNull);
  });

  test('invoice failure → error state, retry recovers', () async {
    invoiceRepository.fail = true;
    var state = await settle();
    expect(state.hasError, isTrue);

    invoiceRepository.fail = false;
    await container.read(provider.notifier).retry();
    state = await settle();

    expect(state.hasError, isFalse);
    expect(state.isReady, isTrue);
  });

  test(
    'markPaid flips to paid with the paid time and unlocks review',
    () async {
      await settle();

      final ok = await container.read(provider.notifier).markPaid();
      final state = container.read(provider);

      expect(ok, isTrue);
      expect(invoiceRepository.markPaidCalls, [bookingId]);
      expect(state.isPaid, isTrue);
      expect(state.invoice!.paidAt, DateTime(2026, 9, 29, 11, 24));
      expect(state.isMarking, isFalse);
      expect(state.markFailed, isFalse);
    },
  );

  test('markPaid failure keeps the invoice unpaid; retry succeeds', () async {
    await settle();
    invoiceRepository.failMarkPaid = true;

    final failed = await container.read(provider.notifier).markPaid();
    expect(failed, isFalse);
    expect(container.read(provider).markFailed, isTrue);
    expect(container.read(provider).isPaid, isFalse);
    expect(container.read(provider).isMarking, isFalse);

    invoiceRepository.failMarkPaid = false;
    final retried = await container.read(provider.notifier).markPaid();
    expect(retried, isTrue);
    expect(container.read(provider).markFailed, isFalse);
    expect(container.read(provider).isPaid, isTrue);
  });

  test('a second markPaid on a paid invoice is a no-op', () async {
    await settle();
    await container.read(provider.notifier).markPaid();

    final again = await container.read(provider.notifier).markPaid();

    expect(again, isFalse);
    expect(invoiceRepository.markPaidCalls, hasLength(1));
  });

  test('an existing review is reflected for the footer', () async {
    invoiceRepository.paid = true;
    reviewRepository.review = Review(
      bookingId: bookingId,
      workshopRating: 5,
      mechanicRatings: const {},
      createdAt: DateTime(2026, 9, 29, 11, 31),
    );

    final state = await settle();

    expect(state.isPaid, isTrue);
    expect(state.hasReview, isTrue);
  });
}
