import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/garage/presentation/garasi/garasi_page.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/motor_detail_page.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/motor_form_page.dart';

import '../support/fake_booking_repository.dart';
import '../support/fake_catalog_repository.dart';
import '../support/fake_garage_repository.dart';
import '../support/fake_session_repository.dart';
import '../support/garage_fixtures.dart';

/// Phone matrix × text scale for the garage screens (S07–S09).
const _phoneSizes = [Size(360, 640), Size(412, 915)];
const _textScales = [1.0, 1.3];

const _models = [
  MotorModel(
    id: 'model_beat',
    brand: MotorBrand.honda,
    name: 'Beat 110',
    category: MotorCategory.matic,
    cc: 110,
  ),
  MotorModel(
    id: 'model_mio',
    brand: MotorBrand.yamaha,
    name: 'Mio M3 125',
    category: MotorCategory.matic,
    cc: 125,
  ),
];

const _berkala = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala dan Ganti Oli Mesin Lengkap',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

final _vario = motorFixture(
  'm_vario',
  nickname: 'Vario 125 Kesayangan Keluarga',
  plate: 'AB 1234 XY',
);
final _beat = motorFixture('m_beat');
final _supra = motorFixture(
  'm_supra',
  nickname: 'Supra X 125',
  plate: 'AB 3344 KL',
  year: null,
);

List<Override> _fakes({bool empty = false}) {
  final garage = FakeGarageRepository()
    ..motorsResult = Result.ok(empty ? [] : [_vario, _beat, _supra])
    ..motorModelsResult = const Result.ok(_models);
  final booking = FakeBookingRepository()
    ..bookingsResult = Result.ok([
      bookingFixture('TS-260929-0417', [
        unitFixture('TS-260929-0417-B', 'm_beat', UnitStatus.dikerjakan),
      ]),
      for (var i = 1; i <= 5; i++)
        bookingFixture('TS-2607140$i', [
          unitFixture(
            'TS-2607140$i-A',
            'm_beat',
            i.isEven ? UnitStatus.dibatalkan : UnitStatus.selesai,
          ),
        ], completedAt: DateTime(2026, 7, i)),
    ]);
  final catalog = FakeCatalogRepository()
    ..serviceTypesResult = const Result.ok([_berkala]);
  final session = FakeSessionRepository()
    ..currentUserResult = const Result.ok(
      User(id: 'user_001', name: 'Galah', phone: '81234567890'),
    );
  return [
    garageRepositoryProvider.overrideWithValue(garage),
    bookingRepositoryProvider.overrideWithValue(booking),
    catalogRepositoryProvider.overrideWithValue(catalog),
    sessionRepositoryProvider.overrideWithValue(session),
  ];
}

void Function(FlutterErrorDetails)? _previousOnError;

List<FlutterErrorDetails> _captureErrors() {
  final errors = <FlutterErrorDetails>[];
  _previousOnError = FlutterError.onError;
  FlutterError.onError = errors.add;
  return errors;
}

void _expectClean(List<FlutterErrorDetails> errors) {
  FlutterError.onError = _previousOnError;
  expect(
    errors,
    isEmpty,
    reason: errors
        .map(
          (e) => e
              .toString(minLevel: DiagnosticLevel.summary)
              .split('\n')
              .take(14)
              .join('\n'),
        )
        .join('\n---\n'),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  Future<void> pumpScreen(
    WidgetTester tester,
    Widget screen, {
    required Size size,
    required double scale,
    bool empty = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: _fakes(empty: empty),
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: screen,
        ),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  final screens = <String, ({Widget Function() build, bool empty})>{
    'S07 populated': (build: GarasiPage.new, empty: false),
    'S07 empty': (build: GarasiPage.new, empty: true),
    'S08 add': (build: MotorFormPage.new, empty: false),
    'S08 edit': (
      build: () => MotorFormPage(existingMotor: _vario),
      empty: false,
    ),
    'S09 in service + history': (
      build: () => const MotorDetailPage(motorId: 'm_beat'),
      empty: false,
    ),
    'S09 free motor': (
      build: () => const MotorDetailPage(motorId: 'm_supra'),
      empty: false,
    ),
  };

  for (final entry in screens.entries) {
    for (final size in _phoneSizes) {
      for (final scale in _textScales) {
        testWidgets('${entry.key} ${size.width.toInt()}×${size.height.toInt()} '
            '@ text ×$scale: no overflow', (tester) async {
          final errors = _captureErrors();
          await pumpScreen(
            tester,
            entry.value.build(),
            size: size,
            scale: scale,
            empty: entry.value.empty,
          );

          _expectClean(errors);
        });
      }
    }
  }

  testWidgets('S08 model picker sheet opens and lists brand groups', (
    tester,
  ) async {
    final errors = _captureErrors();
    await pumpScreen(
      tester,
      const MotorFormPage(),
      size: const Size(360, 800),
      scale: 1.3,
    );

    await tester.tap(find.byType(TextField).at(1));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('Honda'), findsOneWidget);
    expect(find.text('Yamaha'), findsOneWidget);
    expect(find.text('Beat 110'), findsOneWidget);
    _expectClean(errors);
  });

  testWidgets('S09 in service: booking CTA disabled with reason', (
    tester,
  ) async {
    final errors = _captureErrors();
    await pumpScreen(
      tester,
      const MotorDetailPage(motorId: 'm_beat'),
      size: const Size(412, 915),
      scale: 1,
    );

    expect(find.textContaining('Sedang dalam servis'), findsOneWidget);
    expect(find.text('Lacak servis'), findsOneWidget);
    expect(find.text('Hapus motor'), findsOneWidget);
    _expectClean(errors);
  });
}
