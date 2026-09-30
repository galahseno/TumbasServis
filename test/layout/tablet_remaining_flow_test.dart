import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_text_field.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/components/motor_preview_pane.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/components/demo_preview_pane.dart';
import 'package:tumbas_servis/tracking/presentation/detail_booking/detail_booking_page.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/components/booking_history_card.dart';

import '../support/fake_booking_repository.dart';
import '../support/tablet_layout_support.dart';
import '../support/tracking_fixtures.dart';

const _medium = Size(800, 1280);
const _large = Size(1280, 800);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
    await loadAppFonts();
  });

  Future<void> rotate(WidgetTester tester, Size to) async {
    tester.view.physicalSize = to;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  group('S22 sheets become centered modals on tablets', () {
    List<dynamic> scheduled() => richAppOverrides(
      bookingRepository: FakeBookingRepository()
        ..getBookingResult = Result.ok(
          trackedBooking('bk2', [
            trackedUnit('-A', UnitStatus.terjadwal, motorId: 'm1'),
            trackedUnit('-B', UnitStatus.terjadwal, motorId: 'm2'),
          ], slot: slotFixture(date: DateTime(2026, 10, 2), hour: 10)),
        ),
    );

    double materialWidth(WidgetTester tester) => tester
        .getSize(
          find
              .descendant(
                of: find.byType(Dialog),
                matching: find.byType(Material),
              )
              .first,
        )
        .width;

    for (final size in const [_medium, _large]) {
      for (final scale in const [1.0, 1.3]) {
        testWidgets('${size.width.toInt()}×${size.height.toInt()} @ ×$scale: '
            'Ubah jadwal is a ≤560 dialog, Batalkan is ≤400', (tester) async {
          await expectNoLayoutErrorsDuring(() async {
            await pumpShellRoute(
              tester,
              Routes.bookingDetail('bk2'),
              size: size,
              scale: scale,
              overrides: List.of(scheduled().cast()),
            );

            await tester.tap(find.widgetWithText(TsButton, 'Ubah jadwal'));
            await tester.pump(const Duration(milliseconds: 400));
            await tester.pump(const Duration(milliseconds: 400));
            expect(find.byType(BottomSheet), findsNothing);
            expect(find.byType(Dialog), findsOneWidget);
            expect(materialWidth(tester), lessThanOrEqualTo(560));
            await tester.tap(find.byIcon(Icons.close_rounded));
            await tester.pump(const Duration(milliseconds: 400));
            await tester.pump(const Duration(milliseconds: 400));

            await tester.tap(find.widgetWithText(TsButton, 'Batalkan'));
            await tester.pump(const Duration(milliseconds: 400));
            await tester.pump(const Duration(milliseconds: 400));
            expect(find.byType(Dialog), findsOneWidget);
            expect(materialWidth(tester), lessThanOrEqualTo(400));
          });
          await unmountScreen(tester);
        });
      }
    }

    testWidgets('phone keeps the bottom sheet', (tester) async {
      await pumpShellRoute(
        tester,
        Routes.bookingDetail('bk2'),
        size: const Size(393, 852),
        scale: 1,
        overrides: List.of(scheduled().cast()),
      );

      await tester.tap(find.widgetWithText(TsButton, 'Ubah jadwal'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(BottomSheet), findsOneWidget);
      await unmountScreen(tester);
    });
  });

  group('rotation keeps the user\'s place', () {
    testWidgets('S19: selected booking survives large → medium → large', (
      tester,
    ) async {
      await expectNoLayoutErrorsDuring(() async {
        await pumpShellRoute(
          tester,
          Routes.bookings,
          size: _large,
          scale: 1,
          overrides: List.of(
            richAppOverrides(
              bookingRepository: FakeBookingRepository()
                ..bookingsResult = Result.ok([
                  trackedBooking('bkA', [
                    trackedUnit('-A', UnitStatus.dikerjakan, motorId: 'm1'),
                  ]),
                  trackedBooking('bkB', [
                    trackedUnit('-A', UnitStatus.dikerjakan, motorId: 'm2'),
                  ]),
                ])
                ..getBookingResult = Result.ok(
                  trackedBooking('bkB', [
                    trackedUnit('-A', UnitStatus.dikerjakan, motorId: 'm2'),
                  ]),
                ),
            ).cast(),
          ),
        );
        await tester.tap(find.byType(BookingHistoryCard).at(1));
        await tester.pump(const Duration(milliseconds: 200));

        await rotate(tester, _medium);
        expect(find.byType(DetailBookingBody), findsNothing);
        await rotate(tester, _large);

        expect(
          tester
              .widget<DetailBookingBody>(find.byType(DetailBookingBody))
              .bookingId,
          'bkB',
        );
      });
      await unmountScreen(tester);
    });

    testWidgets('S26: previewed unit survives large → medium → large', (
      tester,
    ) async {
      await expectNoLayoutErrorsDuring(() async {
        await pumpShellRoute(
          tester,
          Routes.profileDemoMode,
          size: _large,
          scale: 1,
        );
        await tester.tap(find.textContaining('-B Beat 110').first);
        await tester.pump(const Duration(milliseconds: 200));

        await rotate(tester, _medium);
        expect(find.byType(DemoPreviewPane), findsNothing);
        await rotate(tester, _large);

        expect(
          find.descendant(
            of: find.byType(DemoPreviewPane),
            matching: find.textContaining('Unit -B'),
          ),
          findsOneWidget,
        );
      });
      await unmountScreen(tester);
    });

    testWidgets('S08: typed nickname survives rotation and feeds the '
        'preview again', (tester) async {
      await expectNoLayoutErrorsDuring(() async {
        await pumpShellRoute(tester, Routes.garageAdd, size: _large, scale: 1);
        final field = find.descendant(
          of: find.widgetWithText(TsTextField, 'Nama panggilan'),
          matching: find.byType(TextField),
        );
        await tester.enterText(field, 'Vario 125');
        await tester.pump(const Duration(milliseconds: 100));

        await rotate(tester, _medium);
        expect(tester.widget<TextField>(field).controller!.text, 'Vario 125');
        await rotate(tester, _large);

        expect(
          find.descendant(
            of: find.byType(MotorPreviewPane),
            matching: find.text('Vario 125'),
          ),
          findsOneWidget,
        );
      });
      await unmountScreen(tester);
    });
  });
}
