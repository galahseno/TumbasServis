import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/booking/presentation/components/unit_rail.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/estimate_pane.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/sticky_estimate_bar.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/vehicle_tab_chip.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_grid.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/components/motor_select_card.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_page.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/confirm_pane.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/ringkasan_page.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/ticket_units_panel.dart';
import 'package:tumbas_servis/booking/presentation/tiket/tiket_page.dart';
import 'package:tumbas_servis/booking/presentation/voucher/components/voucher_card.dart';
import 'package:tumbas_servis/booking/presentation/voucher/voucher_page.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/presentation/components/confirm_bar.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/workshop_detail_content.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/detail_bengkel_page.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/state/detail_bengkel_state.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/workshop_card.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/workshop_detail_pane.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/pilih_bengkel_page.dart';

import '../support/layout_test_harness.dart';

const _medium = Size(800, 1280);
const _expanded = Size(1024, 768);
const _large = Size(1280, 800);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  final splitDraft = layoutDraft().copyWith(
    scheduleMode: ScheduleMode.split,
    sharedSlot: null,
    unitSlots: {'m_vario': layoutSlot},
  );

  Future<void> pump(
    WidgetTester tester,
    Widget screen,
    Size size, {
    List<dynamic>? overrides,
  }) => pumpLayoutScreen(
    tester,
    screen,
    size: size,
    scale: 1,
    overrides: overrides == null ? null : List.of(overrides.cast()),
  );

  group('S10 Pilih motor', () {
    double dy(WidgetTester tester, int index) =>
        tester.getTopLeft(find.byType(MotorSelectCard).at(index)).dy;

    testWidgets('medium: 2 columns', (tester) async {
      await pump(tester, const PilihMotorPage(), _medium);
      expect(dy(tester, 0), dy(tester, 1));
      expect(dy(tester, 2), greaterThan(dy(tester, 0)));
    });

    testWidgets('expanded: 3 columns', (tester) async {
      await pump(tester, const PilihMotorPage(), _expanded);
      expect(dy(tester, 0), dy(tester, 1));
      expect(dy(tester, 1), dy(tester, 2));
    });

    testWidgets('large: 3 columns', (tester) async {
      await pump(tester, const PilihMotorPage(), _large);
      expect(dy(tester, 1), dy(tester, 2));
    });
  });

  group('S11 Detail servis', () {
    testWidgets('medium, 3 units: chip row + pill, no rail / pane', (
      tester,
    ) async {
      await pump(tester, const DetailServisPage(), _medium);
      expect(find.byType(VehicleTabChip), findsWidgets);
      expect(find.byType(StickyEstimateBar), findsOneWidget);
      expect(find.byType(UnitRail), findsNothing);
      expect(find.byType(EstimatePane), findsNothing);
    });

    testWidgets('expanded, 3 units: rail + pill', (tester) async {
      await pump(tester, const DetailServisPage(), _expanded);
      expect(find.byType(UnitRail), findsOneWidget);
      expect(find.byType(StickyEstimateBar), findsOneWidget);
      expect(find.byType(VehicleTabChip), findsNothing);
      expect(find.byType(EstimatePane), findsNothing);
    });

    testWidgets('large, 3 units: rail + form + EstimatePane, no pill', (
      tester,
    ) async {
      await pump(tester, const DetailServisPage(), _large);
      expect(find.byType(UnitRail), findsOneWidget);
      expect(find.byType(EstimatePane), findsOneWidget);
      expect(find.byType(StickyEstimateBar), findsNothing);
    });

    testWidgets('large, 1 unit: form + EstimatePane, no rail', (tester) async {
      await pump(
        tester,
        const DetailServisPage(),
        _large,
        overrides: layoutFakes(draft: layoutDraft(motors: ['m_vario'])),
      );
      expect(find.byType(UnitRail), findsNothing);
      expect(find.byType(EstimatePane), findsOneWidget);
    });

    testWidgets('expanded, 1 unit: falls back to the stacked layout', (
      tester,
    ) async {
      await pump(
        tester,
        const DetailServisPage(),
        _expanded,
        overrides: layoutFakes(draft: layoutDraft(motors: ['m_vario'])),
      );
      expect(find.byType(UnitRail), findsNothing);
      expect(find.byType(StickyEstimateBar), findsOneWidget);
    });
  });

  group('S13 Pilih bengkel', () {
    Future<void> pumpS13(WidgetTester tester, Size size) => pump(
      tester,
      const PilihBengkelPage(),
      size,
      overrides: layoutFakes(workshops: layoutWorkshops),
    );

    testWidgets('medium: single list, no detail pane', (tester) async {
      await pumpS13(tester, _medium);
      expect(find.byType(WorkshopCard), findsWidgets);
      expect(find.byType(WorkshopDetailPane), findsNothing);
    });

    for (final size in [_expanded, _large]) {
      testWidgets('${size.width.toInt()}: list-detail with preview', (
        tester,
      ) async {
        await pumpS13(tester, size);
        expect(find.byType(WorkshopDetailPane), findsOneWidget);
        // Default preview = the first card (nothing chosen yet).
        expect(
          tester
              .widget<WorkshopCard>(find.byType(WorkshopCard).first)
              .previewed,
          isTrue,
        );

        await tester.tap(find.byType(WorkshopCard).at(1));
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          tester
              .widget<WorkshopCard>(find.byType(WorkshopCard).at(1))
              .previewed,
          isTrue,
        );
        expect(
          tester
              .widget<WorkshopCard>(find.byType(WorkshopCard).first)
              .previewed,
          isFalse,
        );
      });
    }
  });

  group('S14 Detail bengkel', () {
    const standalone = DetailBengkelPage(
      workshopId: 'ws_001',
      variant: WorkshopDetailVariant.standalone,
    );

    WorkshopDetailLayout layoutOf(WidgetTester tester) => tester
        .widget<WorkshopDetailContent>(find.byType(WorkshopDetailContent))
        .layout;

    testWidgets('medium: stacked', (tester) async {
      await pump(tester, standalone, _medium);
      expect(layoutOf(tester), WorkshopDetailLayout.stacked);
    });

    testWidgets('expanded/large: media + info columns', (tester) async {
      await pump(tester, standalone, _expanded);
      expect(layoutOf(tester), WorkshopDetailLayout.split);
      await pump(tester, standalone, _large);
      expect(layoutOf(tester), WorkshopDetailLayout.split);
    });
  });

  group('S15 Pilih jadwal', () {
    testWidgets('medium shared: date strip, no grid', (tester) async {
      await pump(tester, const PilihJadwalPage(), _medium);
      expect(find.byType(DateGrid), findsNothing);
    });

    testWidgets('expanded + large shared: date grid + slots pane', (
      tester,
    ) async {
      await pump(tester, const PilihJadwalPage(), _expanded);
      expect(find.byType(DateGrid), findsOneWidget);
      await pump(tester, const PilihJadwalPage(), _large);
      expect(find.byType(DateGrid), findsOneWidget);
    });

    testWidgets('large split: rail + date grid + slots', (tester) async {
      await pump(
        tester,
        const PilihJadwalPage(),
        _large,
        overrides: layoutFakes(draft: splitDraft),
      );
      expect(find.byType(UnitRail), findsOneWidget);
      expect(find.byType(DateGrid), findsOneWidget);
    });

    testWidgets('expanded split: stacked accordion (no frame designed)', (
      tester,
    ) async {
      await pump(
        tester,
        const PilihJadwalPage(),
        _expanded,
        overrides: layoutFakes(draft: splitDraft),
      );
      expect(find.byType(UnitRail), findsNothing);
      expect(find.byType(DateGrid), findsNothing);
    });
  });

  group('S16 Ringkasan', () {
    testWidgets('medium: stacked with bottom bar', (tester) async {
      await pump(tester, const RingkasanPage(), _medium);
      expect(find.byType(ConfirmBar), findsOneWidget);
      expect(find.byType(ConfirmPane), findsNothing);
    });

    for (final size in [_expanded, _large]) {
      testWidgets('${size.width.toInt()}: two-pane with ConfirmPane', (
        tester,
      ) async {
        await pump(tester, const RingkasanPage(), size);
        expect(find.byType(ConfirmPane), findsOneWidget);
        expect(find.byType(ConfirmBar), findsNothing);
      });
    }
  });

  group('S17 Voucher', () {
    double dy(WidgetTester tester, int index) =>
        tester.getTopLeft(find.byType(VoucherCard).at(index)).dy;

    testWidgets('medium: one column', (tester) async {
      await pump(
        tester,
        const LayoutSummaryReady(child: VoucherPage()),
        _medium,
      );
      expect(dy(tester, 1), greaterThan(dy(tester, 0)));
    });

    testWidgets('large: cards sit in 2 columns, "Tidak pakai" full width', (
      tester,
    ) async {
      await pump(
        tester,
        const LayoutSummaryReady(child: VoucherPage()),
        _large,
      );
      // 1 eligible voucher + the "Tidak pakai voucher" card.
      final first = tester.getSize(find.byType(VoucherCard).first).width;
      final last = tester.getSize(find.byType(VoucherCard).last).width;
      expect(last, greaterThan(first));
    });
  });

  group('S18 Tiket', () {
    const page = TiketPage(bookingId: 'bk_1');

    testWidgets('medium: single ticket, no status panel', (tester) async {
      await pump(tester, page, _medium);
      expect(find.byType(TicketUnitsPanel), findsNothing);
    });

    for (final size in [_expanded, _large]) {
      testWidgets('${size.width.toInt()}: ticket + status panel', (
        tester,
      ) async {
        await pump(tester, page, size);
        expect(find.byType(TicketUnitsPanel), findsOneWidget);
        expect(find.text('Lacak status'), findsOneWidget);
        expect(find.text('Kembali ke beranda'), findsOneWidget);
      });
    }
  });
}
