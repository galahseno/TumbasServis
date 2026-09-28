import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/vehicle_tab_chip.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_page.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_garage_repository.dart';

const _serviceTypes = [
  ServiceType(
    id: 'svc_berkala',
    name: 'Servis Berkala',
    price: 85000,
    durationMin: 60,
    requiresComplaint: false,
  ),
];

const _parts = [
  Part(
    id: 'part_mpx1',
    name: 'AHM Oli MPX1',
    category: 'Oli',
    brand: 'AHM',
    grade: 'MPX1',
    price: 58000,
    compatibleModelIds: ['model_beat110'],
  ),
  Part(
    id: 'part_mpx2',
    name: 'AHM Oli MPX2',
    category: 'Oli',
    brand: 'AHM',
    grade: 'MPX2',
    price: 70000,
    compatibleModelIds: ['model_vario125', 'model_pcx160'],
  ),
  Part(
    id: 'part_kampas',
    name: 'Kampas Rem Matic',
    category: 'Kampas rem',
    brand: 'Indoparts',
    grade: 'Matic',
    price: 45000,
    compatibleModelIds: ['model_beat110', 'model_vario125', 'model_pcx160'],
  ),
];

Motor _motor(String id, String nickname, String modelId) => Motor(
  id: id,
  ownerId: 'user_001',
  nickname: nickname,
  plateNumber: 'AB 0000 XY',
  modelId: modelId,
);

final _vario = _motor('m_vario', 'Vario 125', 'model_vario125');
final _beat = _motor('m_beat', 'Beat 110', 'model_beat110');
final _pcx = _motor('m_pcx', 'PCX 160', 'model_pcx160');

BookingDraft _draft({
  List<String> selectedMotorIds = const [],
  Map<String, UnitConfig> unitConfigs = const {},
}) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: selectedMotorIds,
  unitConfigs: unitConfigs,
  scheduleMode: ScheduleMode.shared,
  unitSlots: const {},
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

Future<void> _pumpPage(
  WidgetTester tester, {
  required FakeBookingRepository bookingRepository,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final catalogRepository = FakeCatalogRepository()
    ..serviceTypesResult = const Result.ok(_serviceTypes)
    ..partsResult = const Result.ok(_parts);
  final garageRepository = FakeGarageRepository()
    ..motorsResult = Result.ok([_vario, _beat, _pcx]);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        catalogRepositoryProvider.overrideWithValue(catalogRepository),
        garageRepositoryProvider.overrideWithValue(garageRepository),
      ],
      child: MaterialApp(theme: AppTheme.light, home: const DetailServisPage()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapChip(WidgetTester tester, String label) async {
  final finder = find.widgetWithText(VehicleTabChip, label);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
}

void main() {
  testWidgets(
    'estimate bar matches the canonical 3-unit progression as chips are '
    'ticked, and switching tabs preserves each unit\'s selection',
    (tester) async {
      final bookingRepository = FakeBookingRepository()
        ..createDraftResult = Result.ok(
          _draft(selectedMotorIds: const ['m_vario', 'm_beat', 'm_pcx']),
        );
      await _pumpPage(tester, bookingRepository: bookingRepository);

      expect(find.textContaining('Untuk: Vario 125'), findsOneWidget);
      expect(find.text('Pilih layanan untuk Vario 125'), findsOneWidget);

      await tester.tap(find.text('Servis Berkala'));
      await tester.pumpAndSettle();

      expect(find.text('Rp85.000'), findsWidgets);
      expect(find.text('Estimasi · 1 jam'), findsOneWidget);
      expect(find.text('Pilih layanan untuk Beat 110'), findsOneWidget);

      await _tapChip(tester, 'Beat 110');
      await tester.pumpAndSettle();
      expect(find.textContaining('Untuk: Beat 110'), findsOneWidget);

      await tester.tap(find.text('Servis Berkala'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('AHM Oli MPX1'));
      await tester.pumpAndSettle();

      expect(find.text('Rp228.000'), findsOneWidget);
      expect(find.text('Estimasi · 1 jam'), findsOneWidget);
      expect(find.text('Pilih layanan untuk PCX 160'), findsOneWidget);

      await _tapChip(tester, 'PCX 160');
      await tester.pumpAndSettle();
      expect(find.textContaining('Untuk: PCX 160'), findsOneWidget);

      await tester.tap(find.text('Servis Berkala'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('AHM Oli MPX2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kampas Rem Matic'));
      await tester.pumpAndSettle();

      expect(find.text('Rp428.000'), findsOneWidget);
      expect(find.text('Estimasi · 2 jam'), findsOneWidget);
      expect(find.textContaining('Pilih layanan untuk'), findsNothing);

      // Switch back to the first tab and confirm nothing bled between units.
      await _tapChip(tester, 'Vario 125');
      await tester.pumpAndSettle();
      expect(find.text('Rp428.000'), findsOneWidget);
    },
  );

  testWidgets(
    'removing a unit with no selections is immediate; removing one with '
    'selections asks for confirmation and hides the chip row at 1 unit',
    (tester) async {
      final bookingRepository = FakeBookingRepository()
        ..createDraftResult = Result.ok(
          _draft(
            selectedMotorIds: const ['m_vario', 'm_beat', 'm_pcx'],
            unitConfigs: const {
              'm_vario': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
            },
          ),
        );
      await _pumpPage(tester, bookingRepository: bookingRepository);

      // PCX (active by default is Vario; switch to PCX which has no
      // selections) is removed immediately, no dialog.
      await _tapChip(tester, 'PCX 160');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.do_not_disturb_on_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Keluarkan PCX 160 dari booking?'), findsNothing);
      expect(find.text('PCX 160'), findsNothing);
      expect(find.text('Beat 110'), findsOneWidget);

      // Vario has selections: removing it asks for confirmation.
      await _tapChip(tester, 'Vario 125');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.do_not_disturb_on_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Keluarkan Vario 125 dari booking?'), findsOneWidget);

      await tester.tap(find.text('Keluarkan'));
      await tester.pumpAndSettle();

      // Down to 1 unit: the chip row (and its remove control) is hidden.
      expect(find.text('Beat 110'), findsNothing);
      expect(find.byIcon(Icons.do_not_disturb_on_rounded), findsNothing);
    },
  );
}
