import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/utils/ringkasan_display.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/pricing_calculator.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_garage_repository.dart';
import '../../../support/fake_workshop_repository.dart';

const _pricingCalculator = PricingCalculator();

const _jaya = Workshop(
  id: 'ws_001',
  name: 'Bengkel Jaya Motor',
  rating: 4.8,
  reviewCount: 126,
  distanceKm: 1.2,
  address: 'Jl. Melati Raya No. 12, Sleman, DI Yogyakarta',
  openTime: 8,
  closeTime: 17,
  bayCount: 2,
  staticMapAssetPath: 'assets/images/maps/ws_001_map.png',
  serviceIds: ['svc_berkala'],
);

Motor _motor(String id, String nickname, String plate) => Motor(
  id: id,
  ownerId: 'u1',
  nickname: nickname,
  plateNumber: plate,
  modelId: 'model_x',
);

final _vario = _motor('m_vario', 'Vario 125', 'AB 1234 XY');
final _beat = _motor('m_beat', 'Beat 110', 'AB 5678 ZZ');
final _pcx = _motor('m_pcx', 'PCX 160', 'AB 9012 QR');

const _svcBerkala = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

const _oilMpx1 = Part(
  id: 'part_oil_mpx1',
  name: 'AHM Oil MPX1',
  category: 'oli',
  brand: 'AHM',
  grade: 'MPX1',
  price: 58000,
  compatibleModelIds: ['model_x'],
);

const _oilMpx2 = Part(
  id: 'part_oil_mpx2',
  name: 'AHM Oil MPX2',
  category: 'oli',
  brand: 'AHM',
  grade: 'MPX2',
  price: 70000,
  compatibleModelIds: ['model_x'],
);

const _kampasRem = Part(
  id: 'part_kampas_rem',
  name: 'Kampas Rem',
  category: 'rem',
  brand: 'Generic',
  grade: 'Standar',
  price: 45000,
  compatibleModelIds: ['model_x'],
);

final _diskon10 = Voucher(
  id: 'v-diskon10',
  code: 'DISKON10',
  label: 'Diskon 10% servis ≥2 motor',
  discountType: DiscountType.percent,
  discountValue: 10,
  minUnits: 2,
  validUntil: DateTime(2099),
);

final _sharedSlot = TimeSlot(
  date: DateTime(2026, 9, 29),
  hour: 9,
  capacity: 5,
  booked: 1,
);

BookingDraft _canonicalDraft({String? voucherId}) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: ['m_vario', 'm_beat', 'm_pcx'],
  unitConfigs: {
    'm_vario': const UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
    'm_beat': const UnitConfig(
      serviceIds: ['svc_berkala'],
      partIds: ['part_oil_mpx1'],
    ),
    'm_pcx': const UnitConfig(
      serviceIds: ['svc_berkala'],
      partIds: ['part_oil_mpx2', 'part_kampas_rem'],
      complaintNote: 'Rem belakang bunyi saat dingin.',
    ),
  },
  workshopId: 'ws_001',
  scheduleMode: ScheduleMode.shared,
  sharedSlot: _sharedSlot,
  unitSlots: const {},
  voucherId: voucherId,
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

Booking _booking() => Booking(
  id: 'bk_1',
  code: 'TS-260929-0417',
  userId: 'u1',
  workshopId: 'ws_001',
  units: [
    BookingUnit(
      unitCode: '-A',
      motorId: 'm_vario',
      motorSnapshot: _vario,
      serviceIds: const ['svc_berkala'],
      partIds: const [],
      status: UnitStatus.terjadwal,
      statusHistory: [
        StatusEvent(
          status: UnitStatus.terjadwal,
          timestamp: DateTime(2026, 9, 28),
        ),
      ],
      subtotal: 85000,
      durationMin: 60,
    ),
  ],
  scheduleMode: ScheduleMode.shared,
  sharedSlot: _sharedSlot,
  status: BookingStatus.terjadwal,
  voucherId: 'v-diskon10',
  subtotal: 428000,
  discount: 42800,
  total: 385200,
  createdAt: DateTime(2026, 9, 28),
);

void main() {
  group('RingkasanViewModel', () {
    late FakeBookingRepository bookingRepository;
    late FakeWorkshopRepository workshopRepository;
    late FakeGarageRepository garageRepository;
    late FakeCatalogRepository catalogRepository;
    late ProviderContainer container;

    setUpAll(() async {
      // `slotRecapLabel` uses `DateFormatter`, which needs `id_ID` locale
      // data — `bootstrap()` does this for the real app.
      await initializeDateFormatting('id_ID', null);
    });

    setUp(() {
      bookingRepository = FakeBookingRepository()
        ..createDraftResult = Result.ok(
          _canonicalDraft(voucherId: 'v-diskon10'),
        );
      workshopRepository = FakeWorkshopRepository()
        ..workshopResult = const Result.ok(_jaya)
        ..availableSlotsResult = Result.ok([_sharedSlot]);
      garageRepository = FakeGarageRepository()
        ..motorsResult = Result.ok([_vario, _beat, _pcx]);
      catalogRepository = FakeCatalogRepository()
        ..serviceTypesResult = const Result.ok([_svcBerkala])
        ..partsResult = const Result.ok([_oilMpx1, _oilMpx2, _kampasRem])
        ..vouchersResult = Result.ok([_diskon10]);
      container = ProviderContainer(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          workshopRepositoryProvider.overrideWithValue(workshopRepository),
          garageRepositoryProvider.overrideWithValue(garageRepository),
          catalogRepositoryProvider.overrideWithValue(catalogRepository),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<void> waitForLoad() async {
      container.listen(ringkasanViewModelProvider, (_, _) {});
      // Read the notifier once to construct it, then trigger a reload — the
      // view model only self-loads via reload(), matching the page's own
      // "reload on entry" pattern (see ringkasan_page.dart).
      await container.read(ringkasanViewModelProvider.notifier).reload();
    }

    test('loads the canonical 3-unit booking: subtotal 428000, DISKON10 '
        'discount 42800, total 385200', () async {
      await waitForLoad();
      final state = container.read(ringkasanViewModelProvider);

      expect(state.hasError, isFalse);
      expect(state.slotInvalid, isFalse);
      expect(state.voucher?.code, 'DISKON10');

      final draft = container.read(bookingDraftProvider)!;
      final units = buildUnitLines(
        draft: draft,
        motorsById: state.motorsById,
        serviceById: state.serviceById,
        partById: state.partById,
      );
      final breakdown = _pricingCalculator.breakdown(
        unitSubtotals: units.map((u) => u.subtotal).toList(),
        voucher: state.voucher,
      );

      expect(breakdown.subtotal, 428000);
      expect(breakdown.discount, 42800);
      expect(breakdown.total, 385200);
    });

    test('shared slot with insufficient remaining capacity marks the state '
        'invalid with the exact banner copy', () async {
      workshopRepository.availableSlotsResult = Result.ok([
        TimeSlot(date: _sharedSlot.date, hour: 9, capacity: 5, booked: 3),
      ]);
      await waitForLoad();
      final state = container.read(ringkasanViewModelProvider);

      expect(state.slotInvalid, isTrue);
      expect(state.slotInvalidTitle, 'Jam 09.00 sudah tidak muat 3 motor');
      expect(state.slotInvalidBody, contains('Tersisa 2 motor'));
    });

    test('confirm() succeeds and stores the returned booking id', () async {
      bookingRepository.confirmBookingResult = Result.ok(_booking());
      await waitForLoad();

      await container.read(ringkasanViewModelProvider.notifier).confirm();
      final state = container.read(ringkasanViewModelProvider);

      expect(state.confirming, isFalse);
      expect(state.confirmError, isNull);
      expect(state.confirmedBookingId, 'bk_1');
      expect(bookingRepository.confirmBookingCalls, hasLength(1));
    });

    test('confirm() honors DemoModeController.armNextWriteError() without '
        'ever calling the repository', () async {
      await waitForLoad();
      container.read(demoModeControllerProvider).armNextWriteError();

      await container.read(ringkasanViewModelProvider.notifier).confirm();
      final state = container.read(ringkasanViewModelProvider);

      expect(state.confirming, isFalse);
      expect(
        state.confirmError,
        'Booking belum terkirim — periksa koneksi lalu coba lagi.',
      );
      expect(state.confirmedBookingId, isNull);
      expect(bookingRepository.confirmBookingCalls, isEmpty);
    });

    test(
      'removeVoucher then undoRemoveVoucher restores the same voucher',
      () async {
        await waitForLoad();
        final notifier = container.read(ringkasanViewModelProvider.notifier);

        await notifier.removeVoucher();
        expect(container.read(ringkasanViewModelProvider).voucher, isNull);
        expect(container.read(bookingDraftProvider)!.voucherId, isNull);

        await notifier.undoRemoveVoucher();
        final state = container.read(ringkasanViewModelProvider);

        expect(state.voucher?.id, 'v-diskon10');
        expect(container.read(bookingDraftProvider)!.voucherId, 'v-diskon10');
      },
    );
  });
}
