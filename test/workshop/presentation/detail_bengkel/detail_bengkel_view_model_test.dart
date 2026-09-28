import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';
import 'package:tumbas_servis/workshop/presentation/di/workshop_presentation_module.dart';

import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_clock.dart';
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
  serviceIds: ['svc_berkala', 'svc_oli', 'svc_unknown'],
);

// Closed-now specimen: opens at 10, so it's closed at 09.00.
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
  serviceIds: ['svc_berkala'],
);

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

void main() {
  group('DetailBengkelViewModel', () {
    late FakeWorkshopRepository workshopRepository;
    late FakeCatalogRepository catalogRepository;
    late FakeClock clock;
    late ProviderContainer container;

    setUp(() {
      workshopRepository = FakeWorkshopRepository()
        ..workshopsResult = const Result.ok([_jaya, _cahaya]);
      catalogRepository = FakeCatalogRepository()
        ..serviceTypesResult = const Result.ok([_serviceBerkala, _serviceOli]);
      clock = FakeClock(DateTime(2026, 9, 28, 9, 0));
      container = ProviderContainer(
        overrides: [
          workshopRepositoryProvider.overrideWithValue(workshopRepository),
          catalogRepositoryProvider.overrideWithValue(catalogRepository),
          clockProvider.overrideWithValue(clock),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<void> initializeAndWait(String id) async {
      final notifier = container.read(detailBengkelViewModelProvider.notifier);
      await notifier.initialize(id);
      for (var i = 0; i < 100; i++) {
        if (!container.read(detailBengkelViewModelProvider).isLoading) return;
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      throw StateError('DetailBengkelViewModel never finished loading');
    }

    test('initialize loads the matching workshop', () async {
      await initializeAndWait('ws_001');

      final state = container.read(detailBengkelViewModelProvider);
      expect(state.hasError, isFalse);
      expect(state.workshop?.id, 'ws_001');
    });

    test('serviceNamesFor maps a workshop\'s serviceIds to catalog names, '
        'skipping unknown ids', () async {
      await initializeAndWait('ws_001');
      final viewModel = container.read(detailBengkelViewModelProvider.notifier);

      expect(viewModel.serviceNamesFor(_jaya), ['Servis Berkala', 'Ganti Oli']);
    });

    test('an unknown workshop id resolves as an error', () async {
      await initializeAndWait('ws_999');

      expect(container.read(detailBengkelViewModelProvider).hasError, isTrue);
    });

    test('a closed-now workshop (open at 10, now 09.00) still resolves — stays '
        'bookable', () async {
      await initializeAndWait('ws_005');
      final viewModel = container.read(detailBengkelViewModelProvider.notifier);

      expect(viewModel.isOpenNow(_cahaya), isFalse);
      expect(viewModel.statusLineFor(_cahaya), 'Tutup · buka 10.00');
    });

    test('an open-now workshop resolves an open status line', () async {
      clock.setNow(DateTime(2026, 9, 28, 10, 30));
      await initializeAndWait('ws_005');
      final viewModel = container.read(detailBengkelViewModelProvider.notifier);

      expect(viewModel.isOpenNow(_cahaya), isTrue);
      expect(viewModel.statusLineFor(_cahaya), 'Buka · tutup 17.00');
    });
  });
}
