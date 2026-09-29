import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/catalog/presentation/di/catalog_presentation_module.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_garage_repository.dart';

const _mpx1 = Part(
  id: 'part_mpx1',
  name: 'AHM Oli MPX1',
  category: 'Oli',
  brand: 'AHM',
  grade: 'MPX1',
  price: 58000,
  compatibleModelIds: ['model_beat110'],
);
const _mpx2 = Part(
  id: 'part_mpx2',
  name: 'AHM Oli MPX2',
  category: 'Oli',
  brand: 'AHM',
  grade: 'MPX2',
  price: 70000,
  compatibleModelIds: ['model_vario125'],
);
const _kampas = Part(
  id: 'part_kampas',
  name: 'Kampas Rem Matic',
  category: 'Kampas rem',
  brand: 'Indoparts',
  grade: 'Matic',
  price: 45000,
  compatibleModelIds: ['model_beat110', 'model_vario125'],
);
const _parts = [_mpx1, _mpx2, _kampas];

const _beatModel = MotorModel(
  id: 'model_beat110',
  brand: MotorBrand.honda,
  name: 'Beat',
  category: MotorCategory.matic,
  cc: 110,
);
const _varioModel = MotorModel(
  id: 'model_vario125',
  brand: MotorBrand.honda,
  name: 'Vario',
  category: MotorCategory.matic,
  cc: 125,
);

void main() {
  group('KatalogViewModel', () {
    late FakeCatalogRepository catalogRepository;
    late FakeGarageRepository garageRepository;
    late ProviderContainer container;

    setUp(() {
      catalogRepository = FakeCatalogRepository()
        ..partsResult = const Result.ok(_parts);
      garageRepository = FakeGarageRepository()
        ..motorModelsResult = const Result.ok([_beatModel, _varioModel]);
      container = ProviderContainer(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(catalogRepository),
          garageRepositoryProvider.overrideWithValue(garageRepository),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<void> initializeAndWait({
      required Set<String> initialPartIds,
      String? modelId = 'model_beat110',
    }) async {
      await container
          .read(katalogViewModelProvider.notifier)
          .initialize(
            mode: KatalogMode.select,
            modelId: modelId,
            unitNickname: 'Beat 110',
            unitPlateNumber: 'AB 5678 ZZ',
            initialPartIds: initialPartIds,
          );
    }

    test(
      'compat toggle OFF keeps incompatible parts visible with a category+cc '
      'reason; ON hides them',
      () async {
        await initializeAndWait(initialPartIds: const {});
        final viewModel = container.read(katalogViewModelProvider.notifier);

        expect(
          container.read(katalogViewModelProvider).compatOnlyEnabled,
          isTrue,
        );
        expect(
          viewModel.visibleParts.map((p) => p.id),
          isNot(contains('part_mpx2')),
        );

        viewModel.setCompatOnly(false);

        expect(viewModel.visibleParts.map((p) => p.id), contains('part_mpx2'));
        expect(viewModel.isCompatible(_mpx2), isFalse);
        expect(
          viewModel.incompatibleReason(_mpx2),
          'Tidak cocok · untuk matic 125 cc',
        );
      },
    );

    test('search filters the visible list by part name', () async {
      await initializeAndWait(initialPartIds: const {});
      final viewModel = container.read(katalogViewModelProvider.notifier);
      viewModel.setCompatOnly(false);

      viewModel.setSearchQuery('kampas');

      expect(viewModel.visibleParts.map((p) => p.id), ['part_kampas']);
    });

    test('staged selection survives a category-chip change', () async {
      await initializeAndWait(initialPartIds: const {});
      final viewModel = container.read(katalogViewModelProvider.notifier);

      viewModel.toggleStaged('part_mpx1');
      viewModel.setCategory('Kampas rem');

      expect(container.read(katalogViewModelProvider).stagedPartIds, {
        'part_mpx1',
      });
    });

    test('the staged set (what "Selesai" returns) reflects exactly the toggles '
        'made, seeded from the initial partIds', () async {
      await initializeAndWait(initialPartIds: const {'part_mpx1'});
      final viewModel = container.read(katalogViewModelProvider.notifier);

      viewModel.toggleStaged('part_kampas');
      viewModel.toggleStaged('part_mpx1');

      expect(container.read(katalogViewModelProvider).stagedPartIds, {
        'part_kampas',
      });
      expect(viewModel.isDirty, isTrue);
    });
  });
}
