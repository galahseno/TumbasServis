import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';

import '../support/layout_test_harness.dart';
import '../support/tablet_layout_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
    await loadAppFonts();
  });

  const phones = [Size(360, 640), Size(393, 852), Size(412, 915)];

  for (final size in phones) {
    for (final scale in const [1.0, 1.3]) {
      testWidgets(
        'populated Beranda ${size.width.toInt()}×${size.height.toInt()} '
        '@ text ×$scale: no overflow',
        (tester) async {
          final errors = captureLayoutErrors();
          await pumpShellRoute(tester, Routes.home, size: size, scale: scale);
          expectNoLayoutErrors(errors);
          await unmountScreen(tester);
        },
      );
    }
  }
}
