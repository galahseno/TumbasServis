import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/garage/presentation/di/garage_presentation_module.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/state/motor_form_state.dart';

import '../../../support/fake_garage_repository.dart';
import '../../../support/fake_session_repository.dart';
import '../../../support/garage_fixtures.dart';

const _beat = MotorModel(
  id: 'model_beat',
  brand: MotorBrand.honda,
  name: 'Beat 110',
  category: MotorCategory.matic,
  cc: 110,
);
const _mio = MotorModel(
  id: 'model_mio',
  brand: MotorBrand.yamaha,
  name: 'Mio M3 125',
  category: MotorCategory.matic,
  cc: 125,
);
const _ninja = MotorModel(
  id: 'model_ninja',
  brand: MotorBrand.kawasaki,
  name: 'Ninja 250',
  category: MotorCategory.sport,
  cc: 250,
);

void main() {
  late FakeGarageRepository garageRepository;
  late FakeSessionRepository sessionRepository;
  late ProviderContainer container;

  setUp(() {
    garageRepository = FakeGarageRepository()
      ..motorModelsResult = const Result.ok([_mio, _ninja, _beat]);
    sessionRepository = FakeSessionRepository()
      ..currentUserResult = const Result.ok(
        User(id: 'user_001', name: 'Galah', phone: '81234567890'),
      );
    container = ProviderContainer(
      overrides: [
        garageRepositoryProvider.overrideWithValue(garageRepository),
        sessionRepositoryProvider.overrideWithValue(sessionRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  MotorFormState read() => container.read(motorFormViewModelProvider);

  Future<void> initialize({bool edit = false}) async {
    container.listen(motorFormViewModelProvider, (_, _) {});
    await container
        .read(motorFormViewModelProvider.notifier)
        .initialize(existingMotor: edit ? motorFixture('m1') : null);
  }

  test('initialize lists Honda/Yamaha/Suzuki models in brand order', () async {
    await initialize();

    expect(read().models.map((m) => m.id), ['model_beat', 'model_mio']);
    expect(read().isDirty, isFalse);
  });

  test(
    'edit mode is prefilled, resolves the model even if not pickable',
    () async {
      garageRepository.motorsResult = Result.ok([
        motorFixture('m1', modelId: 'model_ninja'),
      ]);
      container.listen(motorFormViewModelProvider, (_, _) {});
      await container
          .read(motorFormViewModelProvider.notifier)
          .initialize(
            existingMotor: motorFixture('m1', modelId: 'model_ninja'),
          );

      expect(read().isEditMode, isTrue);
      expect(read().nickname, 'Beat 110');
      expect(read().plateNumber, 'AB 5678 ZZ');
      expect(read().year, '2021');
      expect(read().selectedModel, _ninja);
      expect(read().isDirty, isFalse);
    },
  );

  test('selectModel prefills an empty nickname only', () async {
    await initialize();
    final vm = container.read(motorFormViewModelProvider.notifier);

    vm.selectModel(_beat);
    expect(read().nickname, 'Beat 110');

    vm.updateNickname('Motor harian');
    vm.selectModel(_mio);
    expect(read().nickname, 'Motor harian');
    expect(read().selectedModel, _mio);
  });

  test(
    'plate blur: invalid shape errors, empty is deferred to submit',
    () async {
      await initialize();
      final vm = container.read(motorFormViewModelProvider.notifier);

      vm.validatePlateOnBlur();
      expect(read().plateError, isNull);

      vm.updatePlate('AB');
      vm.validatePlateOnBlur();
      expect(read().plateError, 'Format plat tidak valid. Contoh: AB 1234 XY');

      vm.updatePlate('AB 1234 XY');
      expect(read().plateError, isNull);
      vm.validatePlateOnBlur();
      expect(read().plateError, isNull);
    },
  );

  test('year blur: optional, 1990-2026 only', () async {
    await initialize();
    final vm = container.read(motorFormViewModelProvider.notifier);

    vm.validateYearOnBlur();
    expect(read().yearError, isNull);

    vm.updateYear('1989');
    vm.validateYearOnBlur();
    expect(read().yearError, 'Tahun 1990–2026');

    vm.updateYear('2027');
    vm.validateYearOnBlur();
    expect(read().yearError, 'Tahun 1990–2026');

    vm.updateYear('2015');
    vm.validateYearOnBlur();
    expect(read().yearError, isNull);
  });

  test('isDirty only after a field differs from the initial values', () async {
    await initialize(edit: true);
    final vm = container.read(motorFormViewModelProvider.notifier);
    expect(read().isDirty, isFalse);

    vm.updateNickname('Beat hitam');
    expect(read().isDirty, isTrue);

    vm.updateNickname('Beat 110');
    expect(read().isDirty, isFalse);
  });

  test('submit on an empty form flags every field, nickname first', () async {
    await initialize();
    final saved = await container
        .read(motorFormViewModelProvider.notifier)
        .submit();

    expect(saved, isFalse);
    expect(read().nicknameError, isNotNull);
    expect(read().modelError, isNotNull);
    expect(read().plateError, isNotNull);
    expect(read().firstInvalidField, MotorFormField.nickname);
    expect(garageRepository.lastAddedMotor, isNull);
  });

  test('nickname over 20 characters is rejected on submit', () async {
    await initialize();
    final vm = container.read(motorFormViewModelProvider.notifier)
      ..selectModel(_beat)
      ..updateNickname('x' * 21)
      ..updatePlate('AB 1234 XY');

    expect(await vm.submit(), isFalse);
    expect(read().nicknameError, 'Maks. 20 karakter');
  });

  test(
    'valid add submit calls addMotor with the owner and picked model',
    () async {
      await initialize();
      final vm = container.read(motorFormViewModelProvider.notifier)
        ..selectModel(_beat)
        ..updatePlate('AB 1234 XY')
        ..updateYear('2020');

      expect(await vm.submit(), isTrue);
      final added = garageRepository.lastAddedMotor!;
      expect(added.ownerId, 'user_001');
      expect(added.modelId, 'model_beat');
      expect(added.nickname, 'Beat 110');
      expect(added.plateNumber, 'AB 1234 XY');
      expect(added.year, 2020);
      expect(garageRepository.lastUpdatedMotor, isNull);
      expect(read().isSaving, isFalse);
    },
  );

  test('edit submit calls updateMotor keeping the id', () async {
    await initialize(edit: true);
    final vm = container.read(motorFormViewModelProvider.notifier)
      ..updateNickname('Beat hitam');

    expect(await vm.submit(), isTrue);
    expect(garageRepository.lastUpdatedMotor?.id, 'm1');
    expect(garageRepository.lastUpdatedMotor?.nickname, 'Beat hitam');
    expect(garageRepository.lastAddedMotor, isNull);
  });

  test(
    'repository error surfaces as the duplicate-plate field error',
    () async {
      garageRepository.addMotorResult = Result.error(Exception('duplicate'));
      await initialize();
      final vm = container.read(motorFormViewModelProvider.notifier)
        ..selectModel(_beat)
        ..updatePlate('AB 1234 XY');

      expect(await vm.submit(), isFalse);
      expect(read().plateError, 'Plat ini sudah ada di garasimu');
      expect(read().plateNumber, 'AB 1234 XY');
      expect(read().firstInvalidField, MotorFormField.plate);
      expect(read().isSaving, isFalse);
    },
  );

  test('missing session user on add surfaces a save error', () async {
    sessionRepository.currentUserResult = const Result.ok(null);
    await initialize();
    final vm = container.read(motorFormViewModelProvider.notifier)
      ..selectModel(_beat)
      ..updatePlate('AB 1234 XY');

    expect(await vm.submit(), isFalse);
    expect(read().saveError, isTrue);
  });
}
