import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/utils/tiket_display.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
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

const _svcBerkala = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

Motor _motor(String id, String nickname) => Motor(
  id: id,
  ownerId: 'u1',
  nickname: nickname,
  plateNumber: 'AB 1234 XY',
  modelId: 'model_x',
);

BookingUnit _unit(
  String code,
  String motorId,
  String nickname, {
  List<String> partIds = const [],
}) => BookingUnit(
  unitCode: code,
  motorId: motorId,
  motorSnapshot: _motor(motorId, nickname),
  serviceIds: const ['svc_berkala'],
  partIds: partIds,
  status: UnitStatus.terjadwal,
  statusHistory: [
    StatusEvent(status: UnitStatus.terjadwal, timestamp: DateTime(2026, 9, 28)),
  ],
  subtotal: 85000,
  durationMin: 60,
);

TimeSlot _slot(int hour) =>
    TimeSlot(date: DateTime(2026, 9, 29), hour: hour, capacity: 5, booked: 1);

Booking _sharedBooking() => Booking(
  id: 'bk_1',
  code: 'TS-260929-0417',
  userId: 'u1',
  workshopId: 'ws_001',
  units: [
    _unit('-A', 'm_vario', 'Vario 125'),
    _unit('-B', 'm_beat', 'Beat 110', partIds: ['p1']),
  ],
  scheduleMode: ScheduleMode.shared,
  sharedSlot: _slot(9),
  status: BookingStatus.terjadwal,
  subtotal: 170000,
  discount: 17000,
  total: 153000,
  createdAt: DateTime(2026, 9, 28),
);

Booking _splitBooking() => _sharedBooking().copyWith(
  scheduleMode: ScheduleMode.split,
  sharedSlot: null,
  unitSlots: {'-A': _slot(9), '-B': _slot(10)},
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TiketViewModel', () {
    late FakeBookingRepository bookingRepository;
    late ProviderContainer container;

    setUpAll(() async {
      await initializeDateFormatting('id_ID', null);
    });

    setUp(() {
      bookingRepository = FakeBookingRepository()
        ..getBookingResult = Result.ok(_sharedBooking());
      container = ProviderContainer(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          workshopRepositoryProvider.overrideWithValue(
            FakeWorkshopRepository()..workshopResult = const Result.ok(_jaya),
          ),
          catalogRepositoryProvider.overrideWithValue(
            FakeCatalogRepository()
              ..serviceTypesResult = const Result.ok([_svcBerkala]),
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('starts loading (track disabled) until load() resolves', () async {
      expect(container.read(tiketViewModelProvider).isLoading, isTrue);
      expect(container.read(tiketViewModelProvider).booking, isNull);

      await container.read(tiketViewModelProvider.notifier).load('bk_1');
      final state = container.read(tiketViewModelProvider);

      expect(state.isLoading, isFalse);
      expect(state.hasError, isFalse);
      expect(state.booking?.code, 'TS-260929-0417');
      expect(state.workshop?.name, 'Bengkel Jaya Motor');
    });

    test('getBooking error → hasError, no booking', () async {
      bookingRepository.getBookingResult = Result.error(Exception('nope'));
      await container.read(tiketViewModelProvider.notifier).load('bk_1');
      final state = container.read(tiketViewModelProvider);

      expect(state.hasError, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.booking, isNull);
    });

    test('copyCode puts the exact booking code on the clipboard and bumps '
        'copyCount', () async {
      String? copied;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              copied = (call.arguments as Map)['text'] as String?;
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );

      final viewModel = container.read(tiketViewModelProvider.notifier);
      await viewModel.load('bk_1');
      await viewModel.copyCode();

      expect(copied, 'TS-260929-0417');
      expect(container.read(tiketViewModelProvider).copyCount, 1);
    });

    test('copyCode before the booking loads does nothing', () async {
      await container.read(tiketViewModelProvider.notifier).copyCode();
      expect(container.read(tiketViewModelProvider).copyCount, 0);
    });
  });

  group('tiket_display', () {
    final services = {'svc_berkala': _svcBerkala};

    test('shared mode: no per-unit slot line, recap shows the slot', () {
      final booking = _sharedBooking();
      final lines = buildTicketUnitLines(
        booking: booking,
        serviceById: services,
      );

      expect(lines.map((l) => l.slotLine), [null, null]);
      expect(lines[0].summary, 'Unit -A · Servis Berkala');
      expect(lines[1].summary, 'Unit -B · Servis Berkala + 1 suku cadang');
      expect(ticketScheduleLine(booking), 'Sel, 29 Sep 2026 · 09.00');
    });

    test('split mode: per-unit slot line + "jam berbeda tiap motor"', () {
      final booking = _splitBooking();
      final lines = buildTicketUnitLines(
        booking: booking,
        serviceById: services,
      );

      expect(lines[0].slotLine, 'Sel, 29 Sep · 09.00');
      expect(lines[1].slotLine, 'Sel, 29 Sep · 10.00');
      expect(
        ticketScheduleLine(booking),
        'Sel, 29 Sep 2026 · jam berbeda tiap motor',
      );
    });

    test('semantics label announces the ticket as one group', () {
      expect(
        ticketSemanticsLabel(
          booking: _sharedBooking(),
          workshopName: 'Bengkel Jaya Motor',
        ),
        'Tiket booking TS-260929-0417, 2 motor, Bengkel Jaya Motor, '
        'Sel, 29 Sep 2026 · 09.00',
      );
    });
  });
}
