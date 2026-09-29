import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_page.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/ringkasan_page.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_clock.dart';
import '../../../support/fake_garage_repository.dart';
import '../../../support/fake_workshop_repository.dart';

const _jaya = Workshop(
  id: 'ws_001',
  name: 'Bengkel Jaya Motor',
  rating: 4.8,
  reviewCount: 126,
  distanceKm: 1.2,
  address: 'Jl. Melati Raya No. 12, Sleman, DI Yogyakarta',
  openTime: 8,
  closeTime: 17,
  bayCount: 2,
  staticMapAssetPath: 'assets/images/maps/ws_001_map.png',
  serviceIds: ['svc_berkala'],
);

const _svc = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

const _vario = Motor(
  id: 'm_vario',
  ownerId: 'u1',
  nickname: 'Vario 125',
  plateNumber: 'AB 1234 XY',
  modelId: 'model_x',
);

final _slot = TimeSlot(
  date: DateTime(2026, 9, 29),
  hour: 9,
  capacity: 5,
  booked: 1,
);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  Future<void> pumpFlow(WidgetTester tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final draft = BookingDraft(
      id: 'draft_1',
      selectedMotorIds: const ['m_vario'],
      unitConfigs: const {
        'm_vario': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
      },
      workshopId: 'ws_001',
      scheduleMode: ScheduleMode.shared,
      sharedSlot: _slot,
      unitSlots: const {},
      createdAt: DateTime(2026, 9, 28),
      expiresAt: DateTime(2026, 9, 29, 12),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('host'),
                  TextButton(
                    onPressed: () => context.push(Routes.bookingSummary),
                    child: const Text('open summary'),
                  ),
                ],
              ),
            ),
          ),
        ),
        GoRoute(
          path: Routes.bookingSummary,
          builder: (_, _) => const RingkasanPage(),
        ),
        GoRoute(
          path: Routes.bookingSchedule,
          builder: (_, _) => const PilihJadwalPage(),
        ),
        GoRoute(
          path: Routes.bookingConfigure,
          builder: (_, _) => const DetailServisPage(),
        ),
        GoRoute(
          path: Routes.bookingWorkshop,
          builder: (_, _) => const Scaffold(body: Text('workshop step')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(
            FakeBookingRepository()..createDraftResult = Result.ok(draft),
          ),
          workshopRepositoryProvider.overrideWithValue(
            FakeWorkshopRepository()
              ..workshopResult = const Result.ok(_jaya)
              ..availableSlotsResult = Result.ok([_slot]),
          ),
          garageRepositoryProvider.overrideWithValue(
            FakeGarageRepository()..motorsResult = const Result.ok([_vario]),
          ),
          catalogRepositoryProvider.overrideWithValue(
            FakeCatalogRepository()
              ..serviceTypesResult = const Result.ok([_svc]),
          ),
          clockProvider.overrideWithValue(
            FakeClock(DateTime(2026, 9, 28, 10, 20)),
          ),
        ],
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open summary'));
    await tester.pumpAndSettle();
    expect(find.text('Ubah jadwal'), findsOneWidget);
  }

  testWidgets('Ubah jadwal → Lanjut returns to the SAME Ringkasan: one back '
      'leaves the flow', (tester) async {
    await pumpFlow(tester);

    await tester.tap(find.text('Ubah jadwal'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih jadwal'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    expect(find.text('Ubah jadwal'), findsOneWidget);
    expect(find.text('Pilih jadwal'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.text('host'), findsOneWidget);
  });

  testWidgets('Ubah motor → Lanjut returns straight to Ringkasan (no extra '
      'Ringkasan pushed)', (tester) async {
    await pumpFlow(tester);

    await tester.tap(find.textContaining('Ubah Vario 125'));
    await tester.pumpAndSettle();
    expect(find.text('Detail servis'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    expect(find.text('workshop step'), findsNothing);
    expect(find.text('Ubah jadwal'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.text('host'), findsOneWidget);
  });

  testWidgets(
    'backing out of an edit with the arrow also keeps one Ringkasan',
    (tester) async {
      await pumpFlow(tester);

      await tester.tap(find.text('Ubah jadwal'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Ubah jadwal'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.text('host'), findsOneWidget);
    },
  );
}
