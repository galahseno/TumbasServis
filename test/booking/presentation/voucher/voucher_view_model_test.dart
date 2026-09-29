import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_clock.dart';
import '../../../support/fake_garage_repository.dart';
import '../../../support/fake_workshop_repository.dart';

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

final _hemat25 = Voucher(
  id: 'v-hemat25',
  code: 'HEMAT25',
  label: 'Potongan Rp25.000 min. belanja Rp300.000',
  discountType: DiscountType.flat,
  discountValue: 25000,
  minSubtotal: 300000,
  validUntil: DateTime(2099),
);

final _fleet15 = Voucher(
  id: 'v-fleet15',
  code: 'FLEET15',
  label: 'Diskon 15% min. 4 motor',
  discountType: DiscountType.percent,
  discountValue: 15,
  minUnits: 4,
  validUntil: DateTime(2099),
);

final _hemat75 = Voucher(
  id: 'v-hemat75',
  code: 'HEMAT75',
  label: 'Potongan Rp75.000 min. belanja Rp500.000',
  discountType: DiscountType.flat,
  discountValue: 75000,
  minSubtotal: 500000,
  validUntil: DateTime(2099),
);

final _sharedSlot = TimeSlot(
  date: DateTime(2026, 9, 29),
  hour: 9,
  capacity: 5,
  booked: 1,
);

const _canonicalUnitConfigs = {
  'm_vario': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
  'm_beat': UnitConfig(serviceIds: ['svc_berkala'], partIds: ['part_oil_mpx1']),
  'm_pcx': UnitConfig(
    serviceIds: ['svc_berkala'],
    partIds: ['part_oil_mpx2', 'part_kampas_rem'],
  ),
};

BookingDraft _draft(List<String> selectedMotorIds) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: selectedMotorIds,
  unitConfigs: {
    for (final id in selectedMotorIds) id: _canonicalUnitConfigs[id]!,
  },
  workshopId: 'ws_001',
  scheduleMode: ScheduleMode.shared,
  sharedSlot: _sharedSlot,
  unitSlots: const {},
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

void main() {
  group('VoucherViewModel', () {
    late FakeBookingRepository bookingRepository;
    late FakeWorkshopRepository workshopRepository;
    late FakeGarageRepository garageRepository;
    late FakeCatalogRepository catalogRepository;
    late ProviderContainer container;

    setUp(() {
      bookingRepository = FakeBookingRepository()
        ..createDraftResult = Result.ok(_draft(['m_vario', 'm_beat', 'm_pcx']));
      workshopRepository = FakeWorkshopRepository()
        ..workshopResult = const Result.ok(_jaya)
        ..availableSlotsResult = Result.ok([_sharedSlot]);
      garageRepository = FakeGarageRepository()
        ..motorsResult = Result.ok([_vario, _beat, _pcx]);
      catalogRepository = FakeCatalogRepository()
        ..serviceTypesResult = const Result.ok([_svcBerkala])
        ..partsResult = const Result.ok([_oilMpx1, _oilMpx2, _kampasRem])
        ..vouchersResult = Result.ok([_diskon10, _hemat25, _fleet15, _hemat75]);
      container = ProviderContainer(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          workshopRepositoryProvider.overrideWithValue(workshopRepository),
          garageRepositoryProvider.overrideWithValue(garageRepository),
          catalogRepositoryProvider.overrideWithValue(catalogRepository),
          clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 27))),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<void> waitForVoucherLoad() async {
      container.listen(ringkasanViewModelProvider, (_, _) {});
      // S17 reuses S16's already-loaded lookups, so S16 must load first.
      await container.read(ringkasanViewModelProvider.notifier).reload();
      container.listen(voucherViewModelProvider, (_, _) {});
      for (var i = 0; i < 100; i++) {
        if (!container.read(voucherViewModelProvider).isLoading) return;
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      throw StateError('VoucherViewModel never finished loading');
    }

    test(
      '3-unit canonical booking: DISKON10 and HEMAT25 are eligible '
      '(sorted by saving, DISKON10 first), FLEET15 and HEMAT75 are not',
      () async {
        await waitForVoucherLoad();
        final state = container.read(voucherViewModelProvider);

        expect(state.hasError, isFalse);
        expect(state.subtotal, 428000);
        expect(state.eligible.map((o) => o.voucher.code), [
          'DISKON10',
          'HEMAT25',
        ]);
        expect(state.eligible[0].savingAmount, 42800);
        expect(state.eligible[1].savingAmount, 25000);
        expect(state.ineligible.map((o) => o.voucher.code), [
          'FLEET15',
          'HEMAT75',
        ]);
        expect(
          state.ineligible
              .firstWhere((o) => o.voucher.code == 'FLEET15')
              .reasonText,
          'Butuh min. 4 motor',
        );
        expect(
          state.ineligible
              .firstWhere((o) => o.voucher.code == 'HEMAT75')
              .reasonText,
          'Min. belanja Rp500.000 — kurang Rp72.000',
        );
      },
    );

    test('single-motor booking makes all four vouchers ineligible', () async {
      bookingRepository.createDraftResult = Result.ok(_draft(['m_vario']));
      await waitForVoucherLoad();
      final state = container.read(voucherViewModelProvider);

      expect(state.eligible, isEmpty);
      expect(state.ineligible, hasLength(4));
    });

    test('after Hapus, a fresh visit can select and apply the same voucher '
        'again (applied flag is not stale)', () async {
      await waitForVoucherLoad();
      var notifier = container.read(voucherViewModelProvider.notifier);
      notifier.selectPending('v-diskon10');
      await notifier.apply();
      expect(container.read(voucherViewModelProvider).applied, isTrue);

      await container.read(bookingDraftProvider.notifier).setVoucher(null);
      container.invalidate(voucherViewModelProvider);
      for (var i = 0; i < 100; i++) {
        if (!container.read(voucherViewModelProvider).isLoading) break;
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }

      notifier = container.read(voucherViewModelProvider.notifier);
      expect(container.read(voucherViewModelProvider).applied, isFalse);
      notifier.selectPending('v-diskon10');
      expect(notifier.hasPendingChange, isTrue);
      await notifier.apply();

      expect(container.read(voucherViewModelProvider).applied, isTrue);
      expect(container.read(bookingDraftProvider)!.voucherId, 'v-diskon10');
    });

    test(
      'apply() persists the pending selection to the draft and marks applied',
      () async {
        await waitForVoucherLoad();
        final notifier = container.read(voucherViewModelProvider.notifier);

        expect(notifier.hasPendingChange, isFalse);
        notifier.selectPending('v-diskon10');
        expect(notifier.hasPendingChange, isTrue);

        await notifier.apply();

        expect(container.read(voucherViewModelProvider).applied, isTrue);
        expect(container.read(bookingDraftProvider)!.voucherId, 'v-diskon10');
      },
    );
  });
}
