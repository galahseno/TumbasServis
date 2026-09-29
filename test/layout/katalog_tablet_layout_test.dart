import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_page.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/presentation/components/ts_switch.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

import '../support/fake_catalog_repository.dart';
import '../support/fake_garage_repository.dart';
import '../support/layout_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final parts = [
    layoutOil,
    for (var i = 0; i < 6; i++)
      Part(
        id: 'part_x$i',
        name: 'Ban Belakang Tubeless Ukuran Panjang Sekali Seri $i',
        category: 'Ban',
        brand: 'IRC',
        grade: 'Sport',
        price: 250000,
        compatibleModelIds: const ['model_other'],
      ),
  ];

  const sizes = [
    Size(800, 1280),
    Size(1280, 800),
    Size(1024, 768),
    Size(673, 841),
  ];

  for (final size in sizes) {
    for (final scale in [1.0, 1.3]) {
      testWidgets(
        'S12 select mode ${size.width.toInt()}×${size.height.toInt()} '
        '@ text ×$scale: no overflow with incompatible parts',
        (tester) async {
          final errors = captureLayoutErrors();
          await pumpLayoutScreen(
            tester,
            const KatalogPage(
              mode: KatalogMode.select,
              selectArgs: KatalogSelectArgs(
                modelId: 'model_x',
                initialPartIds: [],
                unitNickname: 'Vario 125 Kesayangan',
                unitPlateNumber: 'AB 1234 XY',
              ),
            ),
            size: size,
            scale: scale,
            overrides: [
              catalogRepositoryProvider.overrideWithValue(
                FakeCatalogRepository()..partsResult = Result.ok(parts),
              ),
              garageRepositoryProvider.overrideWithValue(
                FakeGarageRepository()..motorsResult = Result.ok([layoutVario]),
              ),
            ],
          );
          await tester.tap(find.byType(TsSwitch));
          await tester.pump(const Duration(milliseconds: 300));
          final sawWarning = find
              .textContaining('Tidak cocok')
              .evaluate()
              .isNotEmpty;

          expectNoLayoutErrors(errors);
          expect(sawWarning, isTrue);
        },
      );
    }
  }
}
