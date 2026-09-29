import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';
import 'package:tumbas_servis/tracking/presentation/detail_booking/state/detail_booking_state.dart';
import 'package:tumbas_servis/tracking/presentation/di/tracking_presentation_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_invoice_repository.dart';
import '../../../support/fake_review_repository.dart';
import '../../../support/fake_tracking_repository.dart';
import '../../../support/fake_workshop_repository.dart';
import '../../../support/tracking_fixtures.dart';

void main() {
  late FakeBookingRepository bookingRepository;
  late FakeTrackingRepository trackingRepository;
  late FakeInvoiceRepository invoiceRepository;
  late FakeReviewRepository reviewRepository;
  late ProviderContainer container;

  setUp(() {
    bookingRepository = FakeBookingRepository();
    trackingRepository = FakeTrackingRepository();
    invoiceRepository = FakeInvoiceRepository();
    reviewRepository = FakeReviewRepository();
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        trackingRepositoryProvider.overrideWithValue(trackingRepository),
        invoiceRepositoryProvider.overrideWithValue(invoiceRepository),
        reviewRepositoryProvider.overrideWithValue(reviewRepository),
        workshopRepositoryProvider.overrideWithValue(
          FakeWorkshopRepository()
            ..workshopResult = const Result.ok(workshopFixture),
        ),
        catalogRepositoryProvider.overrideWithValue(
          FakeCatalogRepository()
            ..serviceTypesResult = const Result.ok(serviceFixtures)
            ..partsResult = const Result.ok(partFixtures),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<DetailBookingState> load(Booking booking) async {
    bookingRepository.getBookingResult = Result.ok(booking);
    final provider = detailBookingViewModelProvider(booking.id);
    container.listen(provider, (_, _) {});
    for (var i = 0; i < 50; i++) {
      if (!container.read(provider).isLoading) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    // Let the invoice/review lookups of finished bookings settle.
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return container.read(provider);
  }

  Booking threeUnits(List<UnitStatus> statuses, {ScheduleMode? mode}) =>
      trackedBooking('bk', [
        for (var i = 0; i < statuses.length; i++)
          trackedUnit(
            '-${String.fromCharCode(65 + i)}',
            statuses[i],
            motorId: 'm$i',
            partIds: i == 1 ? const ['part_oli'] : const [],
          ),
      ], mode: mode ?? ScheduleMode.shared);

  test(
    'loads workshop info and per-unit meta (services + part categories)',
    () async {
      final state = await load(
        threeUnits([UnitStatus.terjadwal, UnitStatus.terjadwal]),
      );

      expect(state.workshopName, 'Bengkel Jaya Motor');
      expect(state.bayCount, 2);
      expect(state.unitMeta['-A'], 'Unit -A · Servis Berkala');
      expect(state.unitMeta['-B'], 'Unit -B · Servis Berkala + Oli');
    },
  );

  group('actions', () {
    test(
      'Terjadwal, shared: both enabled, whole-booking cancel allowed',
      () async {
        final state = await load(
          threeUnits([UnitStatus.terjadwal, UnitStatus.terjadwal]),
        );

        expect(state.showScheduleActions, isTrue);
        expect(state.canReschedule, isTrue);
        expect(state.rescheduleDisabledReason, isNull);
        expect(state.canCancel, isTrue);
        expect(state.canCancelWhole, isTrue);
      },
    );

    test('Terjadwal, split: reschedule disabled with the split reason, '
        'cancel still works', () async {
      final state = await load(
        threeUnits([
          UnitStatus.terjadwal,
          UnitStatus.terjadwal,
        ], mode: ScheduleMode.split),
      );

      expect(state.canReschedule, isFalse);
      expect(
        state.rescheduleDisabledReason,
        DetailBookingState.splitReschedule,
      );
      expect(state.canCancel, isTrue);
    });

    test('checked in: both disabled with the check-in reasons', () async {
      final state = await load(
        threeUnits([UnitStatus.dikerjakan, UnitStatus.dikerjakan]),
      );

      expect(state.status, BookingStatus.berlangsung);
      expect(state.canReschedule, isFalse);
      expect(
        state.rescheduleDisabledReason,
        DetailBookingState.checkedInReschedule,
      );
      expect(state.canCancel, isFalse);
      expect(state.cancelDisabledReason, DetailBookingState.checkedInCancel);
    });

    test(
      'split with one unit still Terjadwal: cancel that unit only',
      () async {
        final state = await load(
          threeUnits([
            UnitStatus.terjadwal,
            UnitStatus.dikerjakan,
          ], mode: ScheduleMode.split),
        );

        expect(state.canCancel, isTrue);
        expect(state.canCancelWhole, isFalse);
        expect(state.terjadwalUnits.map((u) => u.unitCode), ['-A']);
      },
    );

    test('Selesai unpaid: review blocked with the reason', () async {
      final state = await load(
        threeUnits([UnitStatus.selesai, UnitStatus.selesai]),
      );

      expect(state.showScheduleActions, isFalse);
      expect(state.invoicePaid, isFalse);
      expect(state.canReview, isFalse);
      expect(invoiceRepository.getInvoiceCalls, ['bk']);
    });

    test(
      'Selesai paid: review enabled; once reviewed it turns into "lihat"',
      () async {
        invoiceRepository.paid = true;
        final paid = await load(
          threeUnits([UnitStatus.selesai, UnitStatus.selesai]),
        );
        expect(paid.canReview, isTrue);
        expect(paid.hasReview, isFalse);
      },
    );

    test('Selesai paid and reviewed: hasReview, canReview false', () async {
      invoiceRepository.paid = true;
      reviewRepository.review = Review(
        bookingId: 'bk',
        workshopRating: 5,
        mechanicRatings: const {},
        createdAt: DateTime(2026, 9, 29),
      );
      final state = await load(threeUnits([UnitStatus.selesai]));

      expect(state.hasReview, isTrue);
      expect(state.canReview, isFalse);
    });

    test('invoice is never requested before the booking is Selesai', () async {
      await load(threeUnits([UnitStatus.dikerjakan, UnitStatus.qc]));
      expect(invoiceRepository.getInvoiceCalls, isEmpty);
    });

    test(
      'Dibatalkan: no schedule actions, cancelledAt from the last event',
      () async {
        final state = await load(threeUnits([UnitStatus.dibatalkan]));

        expect(state.status, BookingStatus.dibatalkan);
        expect(state.showScheduleActions, isFalse);
        expect(state.cancelledAt, DateTime(2026, 9, 29, 8, 55));
      },
    );
  });

  group('live updates', () {
    test('every non-terminal unit is watched; terminal ones are not', () async {
      await load(threeUnits([UnitStatus.dikerjakan, UnitStatus.selesai]));

      expect(trackingRepository.isWatched('bk', '-A'), isTrue);
      expect(trackingRepository.isWatched('bk', '-B'), isFalse);
    });

    test(
      'a stream emission patches the unit and re-derives the status',
      () async {
        final booking = threeUnits([
          UnitStatus.terjadwal,
          UnitStatus.terjadwal,
        ]);
        final provider = detailBookingViewModelProvider('bk');
        await load(booking);

        trackingRepository.emit(
          'bk',
          trackedUnit('-A', UnitStatus.checkIn, motorId: 'm0'),
        );

        final state = container.read(provider);
        expect(
          state.booking!.units.firstWhere((u) => u.unitCode == '-A').status,
          UnitStatus.checkIn,
        );
        expect(state.status, BookingStatus.berlangsung);
        // Checked in → schedule actions lock live.
        expect(state.canReschedule, isFalse);
      },
    );

    test('the last unit finishing loads the invoice state', () async {
      invoiceRepository.paid = true;
      final provider = detailBookingViewModelProvider('bk');
      await load(threeUnits([UnitStatus.qc]));
      expect(invoiceRepository.getInvoiceCalls, isEmpty);

      trackingRepository.emit(
        'bk',
        trackedUnit('-A', UnitStatus.selesai, motorId: 'm0'),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final state = container.read(provider);
      expect(state.status, BookingStatus.selesai);
      expect(state.invoicePaid, isTrue);
      expect(trackingRepository.isWatched('bk', '-A'), isFalse);
    });

    test('disposing the view model stops watching', () async {
      bookingRepository.getBookingResult = Result.ok(
        threeUnits([UnitStatus.dikerjakan]),
      );
      final subscription = container.listen(
        detailBookingViewModelProvider('bk'),
        (_, _) {},
      );
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(trackingRepository.isWatched('bk', '-A'), isTrue);

      subscription.close();
      await Future<void>.delayed(Duration.zero);

      expect(trackingRepository.isWatched('bk', '-A'), isFalse);
    });
  });

  group('cancel', () {
    test('forwards scope and reason to the repository and reloads', () async {
      final provider = detailBookingViewModelProvider('bk');
      await load(threeUnits([UnitStatus.terjadwal, UnitStatus.terjadwal]));

      final ok = await container
          .read(provider.notifier)
          .cancel(unitCode: '-B', reason: 'Jadwal bentrok');

      expect(ok, isTrue);
      expect(bookingRepository.cancelCalls.single, (
        id: 'bk',
        unitCode: '-B',
        reason: 'Jadwal bentrok',
      ));
      expect(container.read(provider).isMutating, isFalse);
    });

    test('a failed cancel reports false and unlocks the screen', () async {
      final provider = detailBookingViewModelProvider('bk');
      await load(threeUnits([UnitStatus.terjadwal]));
      bookingRepository.cancelBookingResult = Result.error(Exception('x'));

      final ok = await container.read(provider.notifier).cancel();

      expect(ok, isFalse);
      expect(container.read(provider).isMutating, isFalse);
    });
  });

  test('a missing booking is an error state', () async {
    bookingRepository.getBookingResult = Result.error(Exception('gone'));
    final provider = detailBookingViewModelProvider('nope');
    container.listen(provider, (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(container.read(provider).hasError, isTrue);
  });
}
