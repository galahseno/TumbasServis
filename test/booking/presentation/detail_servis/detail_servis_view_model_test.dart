import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_garage_repository.dart';

const _serviceBerkala = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);
const _servicePerbaikan = ServiceType(
  id: 'svc_perbaikan',
  name: 'Perbaikan/Keluhan',
  price: 50000,
  durationMin: 60,
  requiresComplaint: true,
);
const _serviceTypes = [_serviceBerkala, _servicePerbaikan];

const _partMpx1 = Part(
  id: 'part_mpx1',
  name: 'AHM Oli MPX1',
  category: 'Oli',
  brand: 'AHM',
  grade: 'MPX1',
  price: 58000,
  compatibleModelIds: ['model_beat110'],
);
const _partMpx2 = Part(
  id: 'part_mpx2',
  name: 'AHM Oli MPX2',
  category: 'Oli',
  brand: 'AHM',
  grade: 'MPX2',
  price: 70000,
  compatibleModelIds: ['model_vario125', 'model_pcx160'],
);
const _partKampas = Part(
  id: 'part_kampas',
  name: 'Kampas Rem Matic',
  category: 'Kampas rem',
  brand: 'Indoparts',
  grade: 'Matic',
  price: 45000,
  compatibleModelIds: ['model_beat110', 'model_vario125', 'model_pcx160'],
);
const _parts = [_partMpx1, _partMpx2, _partKampas];

Motor _motor(String id, String nickname, String modelId) => Motor(
  id: id,
  ownerId: 'user_001',
  nickname: nickname,
  plateNumber: 'AB 0000 XY',
  modelId: modelId,
);

final _vario = _motor('m_vario', 'Vario 125', 'model_vario125');
final _beat = _motor('m_beat', 'Beat 110', 'model_beat110');
final _pcx = _motor('m_pcx', 'PCX 160', 'model_pcx160');

BookingDraft _draft({
  List<String> selectedMotorIds = const [],
  Map<String, UnitConfig> unitConfigs = const {},
}) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: selectedMotorIds,
  unitConfigs: unitConfigs,
  scheduleMode: ScheduleMode.shared,
  unitSlots: const {},
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

void main() {
  group('unit_config_display pure helpers', () {
    test('unitChipStatus: no services -> incomplete', () {
      expect(
        unitChipStatus(emptyUnitConfig(), _serviceTypes),
        UnitChipStatus.incomplete,
      );
    });

    test('unitChipStatus: requiresComplaint service with no note -> error', () {
      const config = UnitConfig(serviceIds: ['svc_perbaikan'], partIds: []);
      expect(unitChipStatus(config, _serviceTypes), UnitChipStatus.error);
    });

    test(
      'unitChipStatus: requiresComplaint service with a note -> complete',
      () {
        const config = UnitConfig(
          serviceIds: ['svc_perbaikan'],
          partIds: [],
          complaintNote: 'Rem bunyi',
        );
        expect(unitChipStatus(config, _serviceTypes), UnitChipStatus.complete);
      },
    );

    test('unitChipStatus: plain service, no complaint needed -> complete', () {
      const config = UnitConfig(serviceIds: ['svc_berkala'], partIds: []);
      expect(unitChipStatus(config, _serviceTypes), UnitChipStatus.complete);
    });

    test('lanjutBlockedReason names the first incomplete unit by nickname', () {
      final reason = lanjutBlockedReason(
        selectedMotorIds: ['m_vario', 'm_pcx'],
        unitConfigs: {
          'm_vario': const UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
        },
        catalogServices: _serviceTypes,
        nicknameFor: (id) => id == 'm_pcx' ? 'PCX 160' : id,
      );
      expect(reason, 'Pilih layanan untuk PCX 160');
    });

    test('lanjutBlockedReason reports a required-but-empty complaint as a '
        '"Tulis keluhan" reason', () {
      final reason = lanjutBlockedReason(
        selectedMotorIds: ['m_pcx'],
        unitConfigs: {
          'm_pcx': const UnitConfig(serviceIds: ['svc_perbaikan'], partIds: []),
        },
        catalogServices: _serviceTypes,
        nicknameFor: (_) => 'PCX 160',
      );
      expect(reason, 'Tulis keluhan untuk PCX 160');
    });

    test('lanjutBlockedReason is null once every unit is complete', () {
      final reason = lanjutBlockedReason(
        selectedMotorIds: ['m_vario'],
        unitConfigs: {
          'm_vario': const UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
        },
        catalogServices: _serviceTypes,
        nicknameFor: (_) => 'Vario 125',
      );
      expect(reason, isNull);
    });

    test('formatEstimateDuration rounds minutes up to whole hours', () {
      expect(formatEstimateDuration(60), '1 jam');
      expect(formatEstimateDuration(120), '2 jam');
      expect(formatEstimateDuration(61), '2 jam');
    });

    test('copySourceCandidates excludes the active unit and units with no '
        'selections', () {
      final candidates = copySourceCandidates(
        selectedMotorIds: ['m_vario', 'm_beat', 'm_pcx'],
        unitConfigs: {
          'm_beat': const UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
        },
        activeMotorId: 'm_pcx',
      );
      expect(candidates, ['m_beat']);
    });

    test('resolveActiveMotorId falls back once the stored id is removed', () {
      expect(resolveActiveMotorId('m_beat', ['m_vario', 'm_pcx']), 'm_vario');
      expect(resolveActiveMotorId('m_vario', ['m_vario', 'm_pcx']), 'm_vario');
      expect(resolveActiveMotorId(null, []), isNull);
    });
  });

  group('DetailServisViewModel', () {
    late FakeBookingRepository bookingRepository;
    late FakeCatalogRepository catalogRepository;
    late FakeGarageRepository garageRepository;
    late ProviderContainer container;

    setUp(() {
      bookingRepository = FakeBookingRepository()
        ..createDraftResult = Result.ok(_draft());
      catalogRepository = FakeCatalogRepository()
        ..serviceTypesResult = const Result.ok(_serviceTypes)
        ..partsResult = const Result.ok(_parts);
      garageRepository = FakeGarageRepository()
        ..motorsResult = Result.ok([_vario, _beat, _pcx]);
      container = ProviderContainer(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          catalogRepositoryProvider.overrideWithValue(catalogRepository),
          garageRepositoryProvider.overrideWithValue(garageRepository),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<void> waitForLoad() async {
      for (var i = 0; i < 100; i++) {
        if (container.read(bookingDraftProvider) != null &&
            !container.read(detailServisViewModelProvider).isLoading) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      throw StateError('DetailServisViewModel never finished loading');
    }

    test(
      'switching the active tab does not bleed selections between units',
      () async {
        bookingRepository.createDraftResult = Result.ok(
          _draft(selectedMotorIds: const ['m_vario', 'm_beat']),
        );
        await waitForLoad();
        final draftNotifier = container.read(bookingDraftProvider.notifier);
        final viewModel = container.read(
          detailServisViewModelProvider.notifier,
        );

        await draftNotifier.toggleService('m_vario', 'svc_berkala');
        viewModel.setActiveMotor('m_beat');
        await draftNotifier.toggleService('m_beat', 'svc_perbaikan');

        final draft = container.read(bookingDraftProvider)!;
        expect(draft.unitConfigs['m_vario']!.serviceIds, ['svc_berkala']);
        expect(draft.unitConfigs['m_beat']!.serviceIds, ['svc_perbaikan']);
      },
    );

    test(
      'copyFrom drops incompatible parts and records the dropped count',
      () async {
        bookingRepository.createDraftResult = Result.ok(
          _draft(
            selectedMotorIds: const ['m_beat', 'm_vario'],
            unitConfigs: const {
              'm_beat': UnitConfig(
                serviceIds: ['svc_berkala'],
                partIds: ['part_mpx1', 'part_kampas'],
              ),
            },
          ),
        );
        await waitForLoad();
        final viewModel = container.read(
          detailServisViewModelProvider.notifier,
        );
        final draft = container.read(bookingDraftProvider)!;

        await viewModel.copyFrom(
          draft: draft,
          sourceMotorId: 'm_beat',
          targetMotorId: 'm_vario',
          targetModelId: 'model_vario125',
        );

        final updated = container.read(bookingDraftProvider)!;
        final target = updated.unitConfigs['m_vario']!;
        expect(target.serviceIds, ['svc_berkala']);
        expect(target.partIds, ['part_kampas']);
        expect(
          container
              .read(detailServisViewModelProvider)
              .droppedPartsCountByMotor['m_vario'],
          1,
        );
      },
    );

    test('undoCopy restores the target unit to its pre-copy config', () async {
      bookingRepository.createDraftResult = Result.ok(
        _draft(
          selectedMotorIds: const ['m_beat', 'm_vario'],
          unitConfigs: const {
            'm_beat': UnitConfig(
              serviceIds: ['svc_berkala'],
              partIds: ['part_mpx1'],
            ),
            'm_vario': UnitConfig(
              serviceIds: ['svc_perbaikan'],
              partIds: [],
              complaintNote: 'Getar',
            ),
          },
        ),
      );
      await waitForLoad();
      final viewModel = container.read(detailServisViewModelProvider.notifier);
      final draft = container.read(bookingDraftProvider)!;

      await viewModel.copyFrom(
        draft: draft,
        sourceMotorId: 'm_beat',
        targetMotorId: 'm_vario',
        targetModelId: 'model_vario125',
      );
      await viewModel.undoCopy('m_vario');

      final restored = container
          .read(bookingDraftProvider)!
          .unitConfigs['m_vario']!;
      expect(restored.serviceIds, ['svc_perbaikan']);
      expect(restored.complaintNote, 'Getar');
      expect(
        container
            .read(detailServisViewModelProvider)
            .droppedPartsCountByMotor
            .containsKey('m_vario'),
        isFalse,
      );
    });

    test('fleetPriceBreakdown/fleetDurationMin match the canonical 3-unit '
        'progression (2-bay makespan)', () async {
      bookingRepository.createDraftResult = Result.ok(_draft());
      await waitForLoad();
      final viewModel = container.read(detailServisViewModelProvider.notifier);

      final oneUnit = _draft(
        selectedMotorIds: const ['m_vario'],
        unitConfigs: const {
          'm_vario': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
        },
      );
      expect(viewModel.fleetPriceBreakdown(oneUnit).total, 85000);
      expect(viewModel.fleetDurationMin(oneUnit), 60);

      final twoUnits = _draft(
        selectedMotorIds: const ['m_vario', 'm_beat'],
        unitConfigs: const {
          'm_vario': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
          'm_beat': UnitConfig(
            serviceIds: ['svc_berkala'],
            partIds: ['part_mpx1'],
          ),
        },
      );
      expect(viewModel.fleetPriceBreakdown(twoUnits).total, 228000);
      expect(viewModel.fleetDurationMin(twoUnits), 60);

      final threeUnits = _draft(
        selectedMotorIds: const ['m_vario', 'm_beat', 'm_pcx'],
        unitConfigs: const {
          'm_vario': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
          'm_beat': UnitConfig(
            serviceIds: ['svc_berkala'],
            partIds: ['part_mpx1'],
          ),
          'm_pcx': UnitConfig(
            serviceIds: ['svc_berkala'],
            partIds: ['part_mpx2', 'part_kampas'],
          ),
        },
      );
      expect(viewModel.fleetPriceBreakdown(threeUnits).total, 428000);
      expect(viewModel.fleetDurationMin(threeUnits), 120);
    });
  });
}
