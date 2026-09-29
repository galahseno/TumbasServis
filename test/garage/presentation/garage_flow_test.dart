import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/garage_result.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/motor_detail_page.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/motor_form_page.dart';

import '../../support/fake_booking_repository.dart';
import '../../support/fake_catalog_repository.dart';
import '../../support/fake_garage_repository.dart';
import '../../support/fake_session_repository.dart';
import '../../support/garage_fixtures.dart';

const _beatModel = MotorModel(
  id: 'model_beat',
  brand: MotorBrand.honda,
  name: 'Beat 110',
  category: MotorCategory.matic,
  cc: 110,
);

void main() {
  late FakeGarageRepository garageRepository;
  GarageMotorResult? lastResult;
  var popped = false;

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  setUp(() {
    lastResult = null;
    popped = false;
    garageRepository = FakeGarageRepository()
      ..motorModelsResult = const Result.ok([_beatModel])
      ..motorsResult = Result.ok([motorFixture('m1')]);
  });

  Future<void> pumpHost(
    WidgetTester tester, {
    required String openRoute,
    Object? extra,
  }) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async {
                  lastResult = await context.push<GarageMotorResult>(
                    openRoute,
                    extra: extra,
                  );
                  popped = true;
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: Routes.garageAdd,
          builder: (_, state) =>
              MotorFormPage(existingMotor: state.extra as Motor?),
        ),
        GoRoute(
          path: Routes.garageDetailTemplate,
          builder: (_, state) =>
              MotorDetailPage(motorId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: Routes.bookingDetailTemplate,
          builder: (_, _) => const Scaffold(body: Text('booking detail')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          garageRepositoryProvider.overrideWithValue(garageRepository),
          bookingRepositoryProvider.overrideWithValue(FakeBookingRepository()),
          catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
          sessionRepositoryProvider.overrideWithValue(
            FakeSessionRepository()
              ..currentUserResult = const Result.ok(
                User(id: 'user_001', name: 'Galah', phone: '81234567890'),
              ),
          ),
        ],
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    await tester.tap(find.text('open'));
    await _settle(tester);
  }

  testWidgets('add: picking a model and saving pops with created', (
    tester,
  ) async {
    await pumpHost(tester, openRoute: Routes.garageAdd);

    await tester.tap(find.byType(TextField).at(1));
    await _settle(tester);
    await tester.tap(find.text('Beat 110').last);
    await _settle(tester);
    await tester.enterText(find.byType(TextField).at(2), 'ab1234xy');
    await tester.tap(find.text('Simpan'));
    await _settle(tester);

    expect(popped, isTrue);
    expect(lastResult, GarageMotorResult.created);
    expect(garageRepository.lastAddedMotor?.plateNumber, 'AB 1234 XY');
    expect(garageRepository.lastAddedMotor?.nickname, 'Beat 110');
  });

  testWidgets('add: invalid submit stays open with field errors', (
    tester,
  ) async {
    await pumpHost(tester, openRoute: Routes.garageAdd);

    await tester.tap(find.text('Simpan'));
    await _settle(tester);

    expect(popped, isFalse);
    expect(find.text('Nama panggilan wajib diisi'), findsOneWidget);
    expect(find.text('Pilih model motor'), findsOneWidget);
    expect(find.text('Plat nomor wajib diisi'), findsOneWidget);
  });

  testWidgets('back on a clean form pops without a dialog', (tester) async {
    await pumpHost(tester, openRoute: Routes.garageAdd);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await _settle(tester);

    expect(find.text('Buang perubahan?'), findsNothing);
    expect(popped, isTrue);
    expect(lastResult, isNull);
  });

  testWidgets('back on a dirty form asks; "Lanjut mengisi" keeps it open', (
    tester,
  ) async {
    await pumpHost(tester, openRoute: Routes.garageAdd);
    await tester.enterText(find.byType(TextField).at(0), 'Motor');

    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await _settle(tester);
    expect(find.text('Buang perubahan?'), findsOneWidget);

    await tester.tap(find.text('Lanjut mengisi'));
    await _settle(tester);
    expect(popped, isFalse);
    expect(find.text('Tambah motor'), findsOneWidget);
  });

  testWidgets('back on a dirty form: "Buang" discards', (tester) async {
    await pumpHost(tester, openRoute: Routes.garageAdd);
    await tester.enterText(find.byType(TextField).at(0), 'Motor');

    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await _settle(tester);
    await tester.tap(find.text('Buang'));
    await _settle(tester);

    expect(popped, isTrue);
    expect(lastResult, isNull);
  });

  testWidgets('edit save pops with updated', (tester) async {
    await pumpHost(
      tester,
      openRoute: Routes.garageAdd,
      extra: motorFixture('m1', modelId: 'model_beat'),
    );
    expect(find.text('Ubah motor'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Beat hitam');
    await tester.tap(find.text('Simpan perubahan'));
    await _settle(tester);

    expect(lastResult, GarageMotorResult.updated);
    expect(garageRepository.lastUpdatedMotor?.nickname, 'Beat hitam');
  });

  testWidgets('detail: deleting a free motor confirms then pops deleted', (
    tester,
  ) async {
    await pumpHost(tester, openRoute: Routes.garageDetail('m1'));

    await tester.scrollUntilVisible(find.text('Hapus motor'), 200);
    await tester.tap(find.text('Hapus motor'));
    await _settle(tester);
    expect(find.text('Hapus Beat 110?'), findsOneWidget);

    await tester.tap(find.text('Hapus').last);
    await _settle(tester);

    expect(garageRepository.lastDeletedMotorId, 'm1');
    expect(lastResult, GarageMotorResult.deleted);
  });
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}
