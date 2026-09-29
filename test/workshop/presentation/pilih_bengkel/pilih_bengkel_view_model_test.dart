import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';
import 'package:tumbas_servis/workshop/presentation/di/workshop_presentation_module.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/state/pilih_bengkel_state.dart';

import '../../../support/fake_catalog_repository.dart';
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
  serviceIds: ['svc_berkala', 'svc_oli', 'svc_perbaikan'],
);
const _sinarRoda = Workshop(
  id: 'ws_002',
  name: 'Sinar Roda Motor',
  rating: 4.6,
  reviewCount: 90,
  distanceKm: 2.1,
  address: 'Depok, Sleman',
  openTime: 8,
  closeTime: 18,
  bayCount: 3,
  staticMapAssetPath: 'assets/images/maps/ws_002_map.png',
  serviceIds: ['svc_berkala', 'svc_oli', 'svc_perbaikan'],
);
const _kotagede = Workshop(
  id: 'ws_003',
  name: 'Motor Care Kotagede',
  rating: 4.9,
  reviewCount: 200,
  distanceKm: 3.4,
  address: 'Kotagede, Yogyakarta',
  openTime: 8,
  closeTime: 17,
  bayCount: 2,
  staticMapAssetPath: 'assets/images/maps/ws_003_map.png',
  serviceIds: ['svc_berkala', 'svc_oli', 'svc_perbaikan'],
);
const _resmi = Workshop(
  id: 'ws_004',
  name: 'Bengkel Resmi Sumber Rejeki Motor & Spesialis Matic Ngaglik',
  rating: 4.3,
  reviewCount: 40,
  distanceKm: 4.7,
  address: 'Ngaglik, Sleman',
  openTime: 8,
  closeTime: 17,
  bayCount: 1,
  staticMapAssetPath: 'assets/images/maps/ws_004_map.png',
  serviceIds: ['svc_berkala', 'svc_oli', 'svc_perbaikan'],
);
const _cahaya = Workshop(
  id: 'ws_005',
  name: 'Cahaya Motor Gejayan',
  rating: 4.5,
  reviewCount: 60,
  distanceKm: 5.0,
  address: 'Gejayan, Yogyakarta',
  openTime: 10,
  closeTime: 17,
  bayCount: 2,
  staticMapAssetPath: 'assets/images/maps/ws_005_map.png',
  serviceIds: ['svc_berkala', 'svc_oli', 'svc_perbaikan'],
);

const _distanceSorted = [_jaya, _sinarRoda, _kotagede, _resmi, _cahaya];

const _serviceBerkala = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);
const _serviceOli = ServiceType(
  id: 'svc_oli',
  name: 'Ganti Oli',
  price: 58000,
  durationMin: 30,
  requiresComplaint: false,
);

BookingDraft _draft({
  required List<String> selectedMotorIds,
  required Map<String, UnitConfig> unitConfigs,
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
  group('PilihBengkelViewModel', () {
    late FakeWorkshopRepository workshopRepository;
    late FakeCatalogRepository catalogRepository;
    late ProviderContainer container;

    setUp(() {
      workshopRepository = FakeWorkshopRepository()
        ..workshopsResult = const Result.ok(_distanceSorted);
      catalogRepository = FakeCatalogRepository()
        ..serviceTypesResult = const Result.ok([_serviceBerkala, _serviceOli]);
      container = ProviderContainer(
        overrides: [
          workshopRepositoryProvider.overrideWithValue(workshopRepository),
          catalogRepositoryProvider.overrideWithValue(catalogRepository),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<void> waitForLoad() async {
      container.listen(pilihBengkelViewModelProvider, (_, _) {});
      for (var i = 0; i < 100; i++) {
        if (!container.read(pilihBengkelViewModelProvider).isLoading) return;
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      throw StateError('PilihBengkelViewModel never finished loading');
    }

    test('default sort is Terdekat, matching the repository order', () async {
      await waitForLoad();
      final viewModel = container.read(pilihBengkelViewModelProvider.notifier);

      expect(
        container.read(pilihBengkelViewModelProvider).filter,
        WorkshopFilter.terdekat,
      );
      expect(viewModel.visibleWorkshops.map((w) => w.id), [
        'ws_001',
        'ws_002',
        'ws_003',
        'ws_004',
        'ws_005',
      ]);
    });

    test(
      'rating sort re-orders to Kotagede, Jaya, Sinar Roda, Cahaya, Resmi',
      () async {
        await waitForLoad();
        final viewModel = container.read(
          pilihBengkelViewModelProvider.notifier,
        );

        await viewModel.setFilter(WorkshopFilter.ratingTertinggi);

        expect(viewModel.visibleWorkshops.map((w) => w.id), [
          'ws_003',
          'ws_001',
          'ws_002',
          'ws_005',
          'ws_004',
        ]);
      },
    );

    test('filters are mutually exclusive: rating -> buka sekarang -> terdekat '
        'reloads only when open-now changes', () async {
      await waitForLoad();
      final viewModel = container.read(pilihBengkelViewModelProvider.notifier);
      workshopRepository.openNowOnlyCalls.clear();

      await viewModel.setFilter(WorkshopFilter.ratingTertinggi);
      expect(workshopRepository.openNowOnlyCalls, isEmpty);

      await viewModel.setFilter(WorkshopFilter.bukaSekarang);
      expect(workshopRepository.openNowOnlyCalls, [true]);

      await viewModel.setFilter(WorkshopFilter.bukaSekarang);
      expect(workshopRepository.openNowOnlyCalls, [true]);

      await viewModel.setFilter(WorkshopFilter.terdekat);
      expect(workshopRepository.openNowOnlyCalls, [true, false]);
      expect(
        container.read(pilihBengkelViewModelProvider).filter,
        WorkshopFilter.terdekat,
      );
    });

    test('"Buka sekarang" toggle requests the repository with openNowOnly and '
        'reloads', () async {
      await waitForLoad();
      final viewModel = container.read(pilihBengkelViewModelProvider.notifier);
      workshopRepository.workshopsResult = const Result.ok([_jaya]);

      await viewModel.setFilter(WorkshopFilter.bukaSekarang);

      expect(workshopRepository.openNowOnlyCalls, contains(true));
      expect(
        container.read(pilihBengkelViewModelProvider).filter,
        WorkshopFilter.bukaSekarang,
      );
      expect(viewModel.visibleWorkshops.map((w) => w.id), ['ws_001']);
    });

    test('per-workshop estimate matches FleetDurationCalculator makespan over '
        "each workshop's bay count", () async {
      await waitForLoad();
      final viewModel = container.read(pilihBengkelViewModelProvider.notifier);
      final draft = _draft(
        selectedMotorIds: const ['m1', 'm2', 'm3'],
        unitConfigs: const {
          'm1': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
          'm2': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
          'm3': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
        },
      );

      // 3 units x 60 min, over Jaya's 2 bays -> makespan 120 min (2 jam).
      expect(viewModel.estimateMinFor(_jaya, draft), 120);
      // Over Sinar Roda's 3 bays -> makespan 60 min (1 jam).
      expect(viewModel.estimateMinFor(_sinarRoda, draft), 60);
      // Over Resmi's 1 bay -> makespan 180 min (3 jam).
      expect(viewModel.estimateMinFor(_resmi, draft), 180);
      // No draft -> no estimate.
      expect(viewModel.estimateMinFor(_jaya, null), isNull);
    });
  });
}
