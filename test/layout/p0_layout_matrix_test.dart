import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_page.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/ringkasan_page.dart';
import 'package:tumbas_servis/booking/presentation/tiket/tiket_page.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_page.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/pilih_bengkel_page.dart';

import '../support/fake_catalog_repository.dart';
import '../support/fake_garage_repository.dart';
import '../support/fake_session_repository.dart';
import '../support/home_screen_fake_overrides.dart';

import '../support/layout_test_harness.dart';

const _phoneSizes = [
  Size(360, 640),
  Size(360, 800),
  Size(393, 852),
  Size(412, 915),
];
const _textScales = [1.0, 1.3];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  final screens = <String, Widget Function()>{
    'S10 Pilih motor': PilihMotorPage.new,
    'S11 Detail servis': DetailServisPage.new,
    'S13 Pilih bengkel': PilihBengkelPage.new,
    'S15 Pilih jadwal': PilihJadwalPage.new,
    'S16 Ringkasan': RingkasanPage.new,
    'S18 Tiket': () => const TiketPage(bookingId: 'bk_1'),
  };

  for (final entry in screens.entries) {
    for (final size in _phoneSizes) {
      for (final scale in _textScales) {
        testWidgets('${entry.key} ${size.width.toInt()}×${size.height.toInt()} '
            '@ text ×$scale: no overflow', (tester) async {
          final errors = captureLayoutErrors();
          await pumpLayoutScreen(
            tester,
            entry.value(),
            size: size,
            scale: scale,
          );

          expectNoLayoutErrors(errors);
        });
      }
    }
  }

  for (final size in _phoneSizes) {
    for (final scale in _textScales) {
      testWidgets('S05 Home ${size.width.toInt()}×${size.height.toInt()} '
          '@ text ×$scale: no overflow', (tester) async {
        final errors = captureLayoutErrors();
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final container = ProviderContainer(
          overrides: [
            sessionRepositoryProvider.overrideWithValue(
              FakeSessionRepository()
                ..currentUserResult = Result.ok(
                  User(id: 'u1', name: 'Budi', phone: '0812'),
                ),
            ),
            ...homeScreenFakeOverrides(),
          ],
        );
        addTearDown(container.dispose);
        final router = container.read(routerProvider);
        router.go(Routes.home);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              theme: AppTheme.light,
              routerConfig: router,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
            ),
          ),
        );
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }

        expectNoLayoutErrors(errors);
      });
    }
  }

  testWidgets('S12 Katalog empty state with keyboard open (≈300dp inset): '
      'no overflow', (tester) async {
    final errors = captureLayoutErrors();
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);

    final catalog = FakeCatalogRepository()
      ..partsResult = const Result.ok([layoutOil]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(catalog),
          garageRepositoryProvider.overrideWithValue(
            FakeGarageRepository()..motorsResult = Result.ok([layoutVario]),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const _KatalogHost()),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.enterText(find.byType(TextField), 'zzz-tidak-ada');
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Tidak ada suku cadang'), findsOneWidget);
    expectNoLayoutErrors(errors);
  });
}

class _KatalogHost extends StatelessWidget {
  const _KatalogHost();

  @override
  Widget build(BuildContext context) => const KatalogPage(
    mode: KatalogMode.select,
    selectArgs: KatalogSelectArgs(
      modelId: 'model_x',
      initialPartIds: [],
      unitNickname: 'Vario 125',
      unitPlateNumber: 'AB 1234 XY',
    ),
  );
}
