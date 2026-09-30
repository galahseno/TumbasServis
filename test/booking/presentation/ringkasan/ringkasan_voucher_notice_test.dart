import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/ringkasan_page.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
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

final _needsTwoMotors = Voucher(
  id: 'v-diskon10',
  code: 'DISKON10',
  label: 'Diskon 10% servis ≥2 motor',
  discountType: DiscountType.percent,
  discountValue: 10,
  minUnits: 2,
  validUntil: DateTime(2099),
);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets('voucher that no longer qualifies is dropped with one snackbar '
      'and the total loses the discount', (tester) async {
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
      voucherId: 'v-diskon10',
      createdAt: DateTime(2026, 9, 28),
      expiresAt: DateTime(2026, 9, 29, 12),
    );

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
              ..serviceTypesResult = const Result.ok([_svc])
              ..vouchersResult = Result.ok([_needsTwoMotors]),
          ),
          clockProvider.overrideWithValue(
            FakeClock(DateTime(2026, 9, 28, 10, 20)),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const RingkasanPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Voucher DISKON10 dilepas — Butuh min. 2 motor'),
      findsOneWidget,
    );
    expect(find.text('Pilih voucher'), findsWidgets);
    expect(find.textContaining('Hemat'), findsNothing);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(RingkasanPage)),
    );
    expect(container.read(bookingDraftProvider)!.voucherId, isNull);
  });
}
