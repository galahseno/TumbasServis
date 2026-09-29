import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_page.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_garage_repository.dart';

const _oil = Part(
  id: 'part_oil',
  name: 'AHM Oli MPX2',
  category: 'Oli',
  brand: 'AHM',
  grade: 'MPX2',
  price: 70000,
  compatibleModelIds: ['model_x'],
);

void main() {
  testWidgets('tapping the search field keeps focus when the keyboard opens '
      '(layout change must not re-parent the field)', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(
            FakeCatalogRepository()..partsResult = const Result.ok([_oil]),
          ),
          garageRepositoryProvider.overrideWithValue(
            FakeGarageRepository()
              ..motorsResult = Result.ok([
                const Motor(
                  id: 'm1',
                  ownerId: 'u1',
                  nickname: 'Vario 125',
                  plateNumber: 'AB 1234 XY',
                  modelId: 'model_x',
                ),
              ]),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const KatalogPage(
            mode: KatalogMode.select,
            selectArgs: KatalogSelectArgs(
              modelId: 'model_x',
              initialPartIds: [],
              unitNickname: 'Vario 125',
              unitPlateNumber: 'AB 1234 XY',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();

    expect(find.textContaining('Untuk: Vario 125'), findsNothing);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );
  });
}
