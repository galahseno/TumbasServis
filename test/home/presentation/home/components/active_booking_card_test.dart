import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/home/presentation/home/components/active_booking_card.dart';
import 'package:tumbas_servis/home/presentation/home/state/home_state.dart';

void main() {
  testWidgets('tapping the active-booking card fires the navigation intent', (
    tester,
  ) async {
    var tapped = false;
    final motor = Motor(
      id: 'motor_001',
      ownerId: 'user_001',
      nickname: 'Vario 125',
      plateNumber: 'AB 1234 XY',
      modelId: 'model_x',
    );
    final booking = Booking(
      id: 'bk_1',
      code: 'TS-260929-0417',
      userId: 'user_001',
      workshopId: 'ws_001',
      units: [
        BookingUnit(
          unitCode: '-A',
          motorId: 'motor_001',
          motorSnapshot: motor,
          serviceIds: const ['svc_berkala'],
          partIds: const [],
          status: UnitStatus.dikerjakan,
          statusHistory: [
            StatusEvent(
              status: UnitStatus.dikerjakan,
              timestamp: DateTime(2026),
            ),
          ],
          subtotal: 85000,
          durationMin: 60,
        ),
      ],
      scheduleMode: ScheduleMode.shared,
      sharedSlot: TimeSlot(
        date: DateTime(2026, 9, 29),
        hour: 9,
        capacity: 5,
        booked: 1,
      ),
      status: BookingStatus.berlangsung,
      subtotal: 85000,
      discount: 0,
      total: 85000,
      createdAt: DateTime(2026, 9, 20),
    );
    final HomeActiveBookingDisplay display = (
      booking: booking,
      statusLabel: 'Dikerjakan',
      statusCaption: null,
      scheduleLine: 'Bengkel Jaya Motor · Sel, 29 Sep · 09.00',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ActiveBookingCard(display: display, onTap: () => tapped = true),
        ),
      ),
    );

    await tester.tap(find.text('TS-260929-0417'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
