import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_page.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_garage_repository.dart';

BookingDraft _draft({List<String> selectedMotorIds = const []}) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: selectedMotorIds,
  unitConfigs: const {},
  scheduleMode: ScheduleMode.shared,
  unitSlots: const {},
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

Motor _motor(String id) => Motor(
  id: id,
  ownerId: 'user_001',
  nickname: id,
  plateNumber: 'AB 0000 XY',
  modelId: 'model_x',
);

Future<void> _pumpPage(
  WidgetTester tester, {
  required FakeBookingRepository bookingRepository,
  required FakeGarageRepository garageRepository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        garageRepositoryProvider.overrideWithValue(garageRepository),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PilihMotorPage(),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('exit dialog does not appear with 0 motors selected', (
    tester,
  ) async {
    final bookingRepository = FakeBookingRepository()
      ..createDraftResult = Result.ok(_draft());
    final garageRepository = FakeGarageRepository()
      ..motorsResult = Result.ok([_motor('m1')]);
    await _pumpPage(
      tester,
      bookingRepository: bookingRepository,
      garageRepository: garageRepository,
    );

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari booking?'), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets(
    'exit dialog appears with >=1 selected; "Lanjutkan booking" keeps the draft and stays on S10',
    (tester) async {
      final bookingRepository = FakeBookingRepository()
        ..createDraftResult = Result.ok(_draft(selectedMotorIds: const ['m1']));
      final garageRepository = FakeGarageRepository()
        ..motorsResult = Result.ok([_motor('m1')]);
      await _pumpPage(
        tester,
        bookingRepository: bookingRepository,
        garageRepository: garageRepository,
      );

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Keluar dari booking?'), findsOneWidget);

      await tester.tap(find.text('Lanjutkan booking'));
      await tester.pumpAndSettle();

      expect(find.text('Keluar dari booking?'), findsNothing);
      expect(find.text('Pilih motor'), findsOneWidget);
      expect(bookingRepository.draftDeleted, isFalse);
    },
  );

  testWidgets(
    '"Simpan & keluar" exits without discarding the draft (non-destructive)',
    (tester) async {
      final bookingRepository = FakeBookingRepository()
        ..createDraftResult = Result.ok(_draft(selectedMotorIds: const ['m1']));
      final garageRepository = FakeGarageRepository()
        ..motorsResult = Result.ok([_motor('m1')]);
      await _pumpPage(
        tester,
        bookingRepository: bookingRepository,
        garageRepository: garageRepository,
      );

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Simpan & keluar'));
      await tester.pumpAndSettle();

      expect(find.text('open'), findsOneWidget);
      expect(bookingRepository.draftDeleted, isFalse);
    },
  );

  testWidgets(
    'rapid taps on a motor card follow the user (select → deselect → select) '
    'even when the draft write is slow and out of order',
    (tester) async {
      final bookingRepository = _SlowFakeBookingRepository()
        ..createDraftResult = Result.ok(_draft());
      final garageRepository = FakeGarageRepository()
        ..motorsResult = Result.ok([_motor('m1')]);
      await _pumpPage(
        tester,
        bookingRepository: bookingRepository,
        garageRepository: garageRepository,
      );

      final card = find.text('m1');
      await tester.tap(card);
      await tester.pump(const Duration(milliseconds: 10));
      await tester.tap(card);
      await tester.pump(const Duration(milliseconds: 10));
      await tester.tap(card);
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.text('1 dari 5 motor dipilih'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('1 dari 5 motor dipilih'), findsOneWidget);
    },
  );
}

class _SlowFakeBookingRepository extends FakeBookingRepository {
  var _calls = 0;

  @override
  Future<Result<BookingDraft>> updateDraft(BookingDraft draft) async {
    await Future<void>.delayed(
      Duration(milliseconds: _calls++ == 0 ? 400 : 20),
    );
    return super.updateDraft(draft);
  }
}
