import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/booking/presentation/components/unit_rail.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/vehicle_tab_chip.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_chip.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_page.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/workshop_card.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/pilih_bengkel_page.dart';

import '../support/layout_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  Future<void> rotate(WidgetTester tester, Size to) async {
    tester.view.physicalSize = to;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('S11: active unit survives medium chip row → large rail', (
    tester,
  ) async {
    final errors = captureLayoutErrors();
    await pumpLayoutScreen(
      tester,
      const DetailServisPage(),
      size: const Size(800, 1280),
      scale: 1,
    );
    await tester.tap(find.byType(VehicleTabChip).at(1));
    await tester.pump(const Duration(milliseconds: 100));

    await rotate(tester, const Size(1280, 800));

    expect(find.byType(UnitRail), findsOneWidget);
    expect(tester.widget<UnitRail>(find.byType(UnitRail)).activeId, 'm_beat');

    await rotate(tester, const Size(800, 1280));
    expect(find.byType(VehicleTabChip), findsWidgets);
    expectNoLayoutErrors(errors);
  });

  testWidgets('S13: previewed workshop survives expanded ↔ large', (
    tester,
  ) async {
    final errors = captureLayoutErrors();
    await pumpLayoutScreen(
      tester,
      const PilihBengkelPage(),
      size: const Size(1024, 768),
      scale: 1,
      overrides: layoutFakes(workshops: layoutWorkshops),
    );
    await tester.tap(find.byType(WorkshopCard).at(2));
    await tester.pump(const Duration(milliseconds: 100));

    await rotate(tester, const Size(1280, 800));

    expect(
      tester.widget<WorkshopCard>(find.byType(WorkshopCard).at(2)).previewed,
      isTrue,
    );
    expectNoLayoutErrors(errors);
  });

  testWidgets('S15: chosen slot survives portrait → landscape', (tester) async {
    final errors = captureLayoutErrors();
    await pumpLayoutScreen(
      tester,
      const PilihJadwalPage(),
      size: const Size(800, 1280),
      scale: 1,
    );
    bool anySelected() => tester
        .widgetList<SlotChip>(find.byType(SlotChip))
        .any((chip) => chip.selected);

    expect(anySelected(), isTrue);

    await rotate(tester, const Size(1280, 800));
    expect(anySelected(), isTrue);

    await rotate(tester, const Size(800, 1280));
    expect(anySelected(), isTrue);
    expectNoLayoutErrors(errors);
  });
}
