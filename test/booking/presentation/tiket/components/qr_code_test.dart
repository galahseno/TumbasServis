import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/qr_code.dart';

const _code = 'TS-260929-0417';

Widget _host(ThemeData theme) => MaterialApp(
  theme: theme,
  home: const Scaffold(
    body: Center(child: BookingQrCode(data: _code)),
  ),
);

void main() {
  test('the real booking code (and the 5-unit specimen) encode at ECC Q', () {
    // Would throw QrInputTooLongException if a fixed version were too small.
    expect(BookingQrCode.moduleCountFor(_code), greaterThanOrEqualTo(21));
    expect(BookingQrCode.moduleCountFor('TS-261002-0418'), greaterThan(0));
  });

  for (final entry in {
    'light': ThemeData.light(),
    'dark': ThemeData.dark(),
  }.entries) {
    testWidgets('dark-on-light with the code as label in ${entry.key} theme', (
      tester,
    ) async {
      await tester.pumpWidget(_host(entry.value));

      final qr = tester.widget<QrImageView>(find.byType(QrImageView));
      expect(qr.semanticsLabel, 'Kode QR booking $_code');
      expect(qr.size, greaterThanOrEqualTo(126));
      expect(qr.backgroundColor, const Color(0xFFFFFFFF));
      expect(qr.eyeStyle.color, const Color(0xFF1A1716));
      expect(qr.dataModuleStyle.color, const Color(0xFF1A1716));
    });
  }

  testWidgets('tile keeps a 4-module quiet zone around the code', (
    tester,
  ) async {
    await tester.pumpWidget(_host(ThemeData.light()));

    final tile = tester.widget<Container>(
      find
          .ancestor(
            of: find.byType(QrImageView),
            matching: find.byType(Container),
          )
          .first,
    );
    final modules = BookingQrCode.moduleCountFor(_code);
    final size = BookingQrCode.codeSizeFor(_code);
    expect(
      (tile.padding! as EdgeInsets).left,
      closeTo(size / modules * qrQuietZoneModules, 0.001),
    );
    expect(size, greaterThanOrEqualTo(126));
  });
}
