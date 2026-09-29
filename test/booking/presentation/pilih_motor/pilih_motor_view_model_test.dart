import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/utils/selection_footer_display.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

import '../../../support/fake_garage_repository.dart';

Motor _motor(String id) => Motor(
  id: id,
  ownerId: 'user_001',
  nickname: id,
  plateNumber: 'AB 0000 XY',
  modelId: 'model_x',
);

void main() {
  late FakeGarageRepository garageRepository;
  late ProviderContainer container;

  setUp(() {
    garageRepository = FakeGarageRepository();
    container = ProviderContainer(
      overrides: [garageRepositoryProvider.overrideWithValue(garageRepository)],
    );
    addTearDown(container.dispose);
  });

  Future<void> waitForLoad() async {
    container.listen(pilihMotorViewModelProvider, (_, _) {});
    for (var i = 0; i < 100; i++) {
      if (!container.read(pilihMotorViewModelProvider).isLoading) return;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    throw StateError('PilihMotorViewModel never finished loading');
  }

  test('empty-garage state shows the add-motor CTA', () async {
    await waitForLoad();
    final state = container.read(pilihMotorViewModelProvider);

    expect(state.isGarageEmpty, isTrue);
  });

  test('loads motors from the garage repository', () async {
    garageRepository.motorsResult = Result.ok([_motor('m1'), _motor('m2')]);
    await waitForLoad();
    final state = container.read(pilihMotorViewModelProvider);

    expect(state.motors, hasLength(2));
    expect(state.isGarageEmpty, isFalse);
  });

  test('a repository error surfaces as hasError', () async {
    garageRepository.motorsResult = Result.error(Exception('boom'));
    await waitForLoad();
    final state = container.read(pilihMotorViewModelProvider);

    expect(state.hasError, isTrue);
  });

  group('selectionReasonLine', () {
    test('shows a loading reason while fetching', () {
      expect(
        selectionReasonLine(isLoading: true, selectedCount: 0),
        'Memuat daftar motor…',
      );
    });

    test('"Lanjut" reason at 0 selected', () {
      expect(
        selectionReasonLine(isLoading: false, selectedCount: 0),
        'Pilih minimal 1 motor',
      );
    });

    test('"Lanjut" reason at the 5-motor max', () {
      expect(
        selectionReasonLine(isLoading: false, selectedCount: 5),
        'Lepas satu untuk memilih motor lain',
      );
    });

    test('no reason line for 1-4 selected', () {
      expect(selectionReasonLine(isLoading: false, selectedCount: 3), isNull);
    });
  });
}
