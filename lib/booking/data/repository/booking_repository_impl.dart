// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/data/service/slot_occupancy_calculator.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/repository/booking/booking_repository.dart';
import 'package:tumbas_servis/core/domain/repository/catalog/catalog_repository.dart';
import 'package:tumbas_servis/core/domain/repository/garage/garage_repository.dart';
import 'package:tumbas_servis/core/domain/repository/session/session_repository.dart';
import 'package:tumbas_servis/core/domain/service/clock.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/fleet_duration_calculator.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/pricing_calculator.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/core/domain/service/status/booking_status_derivation.dart';
import 'package:tumbas_servis/core/domain/service/voucher/voucher_eligibility_service.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({
    required LocalStore localStore,
    required MockJsonLoader mockJsonLoader,
    required LatencySimulator latencySimulator,
    required Clock clock,
    required CatalogRepository catalogRepository,
    required GarageRepository garageRepository,
    required SessionRepository sessionRepository,
  }) : _localStore = localStore,
       _mockJsonLoader = mockJsonLoader,
       _latencySimulator = latencySimulator,
       _clock = clock,
       _catalogRepository = catalogRepository,
       _garageRepository = garageRepository,
       _sessionRepository = sessionRepository;

  final LocalStore _localStore;
  final MockJsonLoader _mockJsonLoader;
  final LatencySimulator _latencySimulator;
  final Clock _clock;
  final CatalogRepository _catalogRepository;
  final GarageRepository _garageRepository;
  final SessionRepository _sessionRepository;

  static const _bookingsBox = SlotOccupancyCalculator.bookingsBox;
  static const _draftBox = 'booking_drafts';
  static const _draftKey = 'current';
  static const _counterBox = 'booking_code_counters';
  static const _capacity = 5;
  static const _unitCodeSuffixes = ['-A', '-B', '-C', '-D', '-E'];

  static const _slotOccupancy = SlotOccupancyCalculator();
  static const _pricingCalculator = PricingCalculator();
  static const _fleetDurationCalculator = FleetDurationCalculator();
  static const _slotCapacityService = SlotCapacityService();
  static const _voucherEligibilityService = VoucherEligibilityService();
  static const _statusDerivation = BookingStatusDerivation();

  @override
  Future<Result<BookingDraft>> createDraft() async {
    try {
      await _latencySimulator.simulate();
      final now = _clock.now();
      final existing = await _localStore.get(_draftBox, _draftKey);
      if (existing != null) {
        final draft = _draftFromJson(existing);
        if (now.isBefore(draft.expiresAt)) {
          return Result.ok(draft);
        }
        await _localStore.delete(_draftBox, _draftKey);
      }
      final draft = BookingDraft(
        id: 'draft_${now.microsecondsSinceEpoch}',
        selectedMotorIds: const [],
        unitConfigs: const {},
        scheduleMode: ScheduleMode.shared,
        unitSlots: const {},
        createdAt: now,
        expiresAt: now.add(const Duration(hours: 24)),
      );
      await _localStore.put(_draftBox, _draftKey, _draftToJson(draft));
      return Result.ok(draft);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<BookingDraft>> updateDraft(BookingDraft draft) async {
    try {
      await _latencySimulator.simulate();
      if (_clock.now().isAfter(draft.expiresAt)) {
        return Result.error(Exception('Draft booking sudah kedaluwarsa.'));
      }
      await _localStore.put(_draftBox, _draftKey, _draftToJson(draft));
      return Result.ok(draft);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<Booking>> confirmBooking(BookingDraft draft) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();

      final now = _clock.now();
      if (now.isAfter(draft.expiresAt)) {
        return Result.error(Exception('Draft booking sudah kedaluwarsa.'));
      }
      if (draft.selectedMotorIds.isEmpty) {
        return Result.error(Exception('Belum ada motor yang dipilih.'));
      }

      final capacityError = await _validateCapacity(draft);
      if (capacityError != null) return Result.error(capacityError);

      final userResult = await _sessionRepository.currentUser();
      if (userResult is Error<User?>) return Result.error(userResult.error);
      final user = (userResult as Ok<User?>).value;
      if (user == null) {
        return Result.error(Exception('Anda belum login.'));
      }

      final serviceTypesResult = await _catalogRepository.getServiceTypes();
      if (serviceTypesResult is Error<List<ServiceType>>) {
        return Result.error(serviceTypesResult.error);
      }
      final serviceById = {
        for (final s in (serviceTypesResult as Ok<List<ServiceType>>).value)
          s.id: s,
      };

      final partsResult = await _catalogRepository.getParts();
      if (partsResult is Error<List<Part>>) {
        return Result.error(partsResult.error);
      }
      final partById = {
        for (final p in (partsResult as Ok<List<Part>>).value) p.id: p,
      };

      final motorsResult = await _garageRepository.getMotors();
      if (motorsResult is Error<List<Motor>>) {
        return Result.error(motorsResult.error);
      }
      final motorById = {
        for (final m in (motorsResult as Ok<List<Motor>>).value) m.id: m,
      };

      Voucher? voucher;
      if (draft.voucherId != null) {
        final vouchersResult = await _catalogRepository.getVouchers();
        if (vouchersResult is Error<List<Voucher>>) {
          return Result.error(vouchersResult.error);
        }
        final voucherById = {
          for (final v in (vouchersResult as Ok<List<Voucher>>).value) v.id: v,
        };
        voucher = voucherById[draft.voucherId];
        if (voucher == null) {
          return Result.error(Exception('Voucher tidak ditemukan.'));
        }
      }

      final units = <BookingUnit>[];
      final unitCodeByMotorId = <String, String>{};
      for (var i = 0; i < draft.selectedMotorIds.length; i++) {
        final motorId = draft.selectedMotorIds[i];
        final motor = motorById[motorId];
        if (motor == null) {
          return Result.error(Exception('Motor tidak ditemukan: $motorId'));
        }
        final config = draft.unitConfigs[motorId];
        if (config == null) {
          return Result.error(
            Exception('Konfigurasi servis belum lengkap untuk $motorId'),
          );
        }
        final services = <ServiceType>[];
        for (final serviceId in config.serviceIds) {
          final service = serviceById[serviceId];
          if (service == null) {
            return Result.error(
              Exception('Layanan tidak ditemukan: $serviceId'),
            );
          }
          services.add(service);
        }
        final parts = <Part>[];
        for (final partId in config.partIds) {
          final part = partById[partId];
          if (part == null) {
            return Result.error(Exception('Part tidak ditemukan: $partId'));
          }
          parts.add(part);
        }
        final unitCode = _unitCodeSuffixes[i];
        unitCodeByMotorId[motorId] = unitCode;
        units.add(
          BookingUnit(
            unitCode: unitCode,
            motorId: motorId,
            motorSnapshot: motor,
            serviceIds: config.serviceIds,
            partIds: config.partIds,
            complaintNote: config.complaintNote,
            status: UnitStatus.terjadwal,
            statusHistory: [
              StatusEvent(status: UnitStatus.terjadwal, timestamp: now),
            ],
            subtotal: _pricingCalculator.unitSubtotal(
              services: services,
              parts: parts,
            ),
            durationMin: _fleetDurationCalculator.unitDurationMin(services),
          ),
        );
      }

      final unitSubtotals = units.map((u) => u.subtotal).toList();
      final subtotal = _pricingCalculator.fleetSubtotal(unitSubtotals);
      var discount = 0;
      String? appliedVoucherId;
      if (voucher != null) {
        final eligibility = _voucherEligibilityService.evaluate(
          voucher: voucher,
          unitCount: units.length,
          subtotal: subtotal,
          now: now,
        );
        if (eligibility.isEligible) {
          discount = eligibility.discountAmount ?? 0;
          appliedVoucherId = voucher.id;
        }
      }

      final DateTime referenceDate;
      if (draft.scheduleMode == ScheduleMode.split) {
        final dates = draft.selectedMotorIds
            .map((id) => draft.unitSlots[id]?.date)
            .whereType<DateTime>()
            .toList();
        referenceDate = dates.isEmpty
            ? now
            : dates.reduce((a, b) => a.isBefore(b) ? a : b);
      } else {
        referenceDate = draft.sharedSlot!.date;
      }
      final code = await _nextCode(referenceDate);

      final booking = Booking(
        id: 'bk_${now.microsecondsSinceEpoch}',
        code: code,
        userId: user.id,
        workshopId: draft.workshopId!,
        units: units,
        scheduleMode: draft.scheduleMode,
        sharedSlot: draft.scheduleMode == ScheduleMode.shared
            ? draft.sharedSlot
            : null,
        unitSlots: draft.scheduleMode == ScheduleMode.split
            ? {
                for (final motorId in draft.selectedMotorIds)
                  unitCodeByMotorId[motorId]!: draft.unitSlots[motorId]!,
              }
            : null,
        status: BookingStatus.terjadwal,
        voucherId: appliedVoucherId,
        subtotal: subtotal,
        discount: discount,
        total: subtotal - discount,
        createdAt: now,
      );

      await _localStore.put(_bookingsBox, booking.id, _bookingToJson(booking));
      await _localStore.delete(_draftBox, _draftKey);
      return Result.ok(booking);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Booking>>> getBookings({BookingStatus? status}) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      final rows = await _localStore.getAll(_bookingsBox);
      final bookings = rows
          .map(_bookingFromJson)
          .where((b) => status == null || b.status == status)
          .toList();
      return Result.ok(bookings);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<Booking>> getBooking(String id) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      final row = await _localStore.get(_bookingsBox, id);
      if (row == null) {
        return Result.error(Exception('Booking not found: $id'));
      }
      return Result.ok(_bookingFromJson(row));
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> cancelBooking(String id, {String? unitCode}) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      final row = await _localStore.get(_bookingsBox, id);
      if (row == null) {
        return Result.error(Exception('Booking not found: $id'));
      }
      final booking = _bookingFromJson(row);
      final now = _clock.now();

      List<BookingUnit> updatedUnits;
      if (unitCode == null) {
        if (booking.status != BookingStatus.terjadwal) {
          return Result.error(
            Exception('Booking ini sudah tidak bisa dibatalkan seluruhnya.'),
          );
        }
        updatedUnits = booking.units
            .map(
              (u) => u.copyWith(
                status: UnitStatus.dibatalkan,
                statusHistory: [
                  ...u.statusHistory,
                  StatusEvent(
                    status: UnitStatus.dibatalkan,
                    timestamp: now,
                    note: 'Dibatalkan oleh pengguna.',
                  ),
                ],
              ),
            )
            .toList();
      } else {
        final target = _find(booking.units, (u) => u.unitCode == unitCode);
        if (target == null) {
          return Result.error(Exception('Unit not found: $unitCode'));
        }
        if (target.status != UnitStatus.terjadwal) {
          return Result.error(
            Exception('Unit ini sudah tidak bisa dibatalkan.'),
          );
        }
        updatedUnits = booking.units
            .map(
              (u) => u.unitCode != unitCode
                  ? u
                  : u.copyWith(
                      status: UnitStatus.dibatalkan,
                      statusHistory: [
                        ...u.statusHistory,
                        StatusEvent(
                          status: UnitStatus.dibatalkan,
                          timestamp: now,
                          note: 'Dibatalkan oleh pengguna.',
                        ),
                      ],
                    ),
            )
            .toList();
      }

      final remaining = updatedUnits
          .where((u) => u.status != UnitStatus.dibatalkan)
          .toList();
      final subtotal = _pricingCalculator.fleetSubtotal(
        remaining.map((u) => u.subtotal).toList(),
      );

      var discount = 0;
      String? appliedVoucherId;
      if (booking.voucherId != null && remaining.isNotEmpty) {
        final vouchersResult = await _catalogRepository.getVouchers();
        if (vouchersResult is Error<List<Voucher>>) {
          return Result.error(vouchersResult.error);
        }
        final voucher = _find(
          (vouchersResult as Ok<List<Voucher>>).value,
          (v) => v.id == booking.voucherId,
        );
        if (voucher != null) {
          final eligibility = _voucherEligibilityService.evaluate(
            voucher: voucher,
            unitCount: remaining.length,
            subtotal: subtotal,
            now: now,
          );
          if (eligibility.isEligible) {
            discount = eligibility.discountAmount ?? 0;
            appliedVoucherId = voucher.id;
          }
        }
      }

      final updatedBooking = booking.copyWith(
        units: updatedUnits,
        subtotal: subtotal,
        discount: discount,
        total: subtotal - discount,
        voucherId: appliedVoucherId,
        status: _statusDerivation.deriveStatus(
          updatedUnits.map((u) => u.status).toList(),
        ),
      );

      await _localStore.put(
        _bookingsBox,
        updatedBooking.id,
        _bookingToJson(updatedBooking),
      );
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<Booking>> rescheduleBooking({
    required String id,
    TimeSlot? newSharedSlot,
    Map<String, TimeSlot>? newUnitSlots,
  }) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      final row = await _localStore.get(_bookingsBox, id);
      if (row == null) {
        return Result.error(Exception('Booking not found: $id'));
      }
      final booking = _bookingFromJson(row);
      final now = _clock.now();

      if (booking.scheduleMode == ScheduleMode.shared) {
        if (newSharedSlot == null) {
          return Result.error(
            Exception(
              'newSharedSlot is required to reschedule a shared-mode booking.',
            ),
          );
        }
        if (booking.units.any((u) => u.status != UnitStatus.terjadwal)) {
          return Result.error(
            Exception('Booking ini sudah tidak bisa dijadwal ulang.'),
          );
        }
        final freshBooked = await _slotOccupancy.bookedCount(
          localStore: _localStore,
          workshopId: booking.workshopId,
          date: newSharedSlot.date,
          hour: newSharedSlot.hour,
          capacity: _capacity,
        );
        final freshSlot = TimeSlot(
          date: newSharedSlot.date,
          hour: newSharedSlot.hour,
          capacity: _capacity,
          booked: freshBooked,
        );
        if (!_slotCapacityService.hasSharedCapacityFor(
          slot: freshSlot,
          unitCount: booking.units.length,
        )) {
          return Result.error(Exception('Slot penuh, silakan pilih jam lain.'));
        }
        final updatedUnits = booking.units
            .map(
              (u) => u.copyWith(
                statusHistory: [
                  ...u.statusHistory,
                  StatusEvent(
                    status: UnitStatus.terjadwal,
                    timestamp: now,
                    note: 'Dijadwal ulang ke ${_formatSlot(newSharedSlot)}.',
                  ),
                ],
              ),
            )
            .toList();
        final updated = booking.copyWith(
          sharedSlot: newSharedSlot,
          units: updatedUnits,
        );
        await _localStore.put(
          _bookingsBox,
          updated.id,
          _bookingToJson(updated),
        );
        return Result.ok(updated);
      }

      if (newUnitSlots == null || newUnitSlots.isEmpty) {
        return Result.error(
          Exception(
            'newUnitSlots is required to reschedule a split-mode booking.',
          ),
        );
      }
      for (final unitCode in newUnitSlots.keys) {
        final unit = _find(booking.units, (u) => u.unitCode == unitCode);
        if (unit == null || unit.status != UnitStatus.terjadwal) {
          return Result.error(
            Exception('Unit $unitCode sudah tidak bisa dijadwal ulang.'),
          );
        }
      }
      final byKey = <String, List<String>>{};
      for (final entry in newUnitSlots.entries) {
        final key = _slotKey(entry.value);
        byKey.putIfAbsent(key, () => []).add(entry.key);
      }
      for (final group in byKey.values) {
        final slot = newUnitSlots[group.first]!;
        final freshBooked = await _slotOccupancy.bookedCount(
          localStore: _localStore,
          workshopId: booking.workshopId,
          date: slot.date,
          hour: slot.hour,
          capacity: _capacity,
        );
        for (var i = 0; i < group.length; i++) {
          final freshSlot = TimeSlot(
            date: slot.date,
            hour: slot.hour,
            capacity: _capacity,
            booked: freshBooked,
          );
          if (!_slotCapacityService.canSplitPlaceUnit(
            slot: freshSlot,
            siblingsAlreadyPlaced: i,
          )) {
            return Result.error(
              Exception('Slot penuh, silakan pilih jam lain.'),
            );
          }
        }
      }
      final updatedUnitSlots = Map<String, TimeSlot>.from(
        booking.unitSlots ?? const {},
      )..addAll(newUnitSlots);
      final updatedUnits = booking.units.map((u) {
        final newSlot = newUnitSlots[u.unitCode];
        if (newSlot == null) return u;
        return u.copyWith(
          statusHistory: [
            ...u.statusHistory,
            StatusEvent(
              status: UnitStatus.terjadwal,
              timestamp: now,
              note: 'Dijadwal ulang ke ${_formatSlot(newSlot)}.',
            ),
          ],
        );
      }).toList();
      final updated = booking.copyWith(
        unitSlots: updatedUnitSlots,
        units: updatedUnits,
      );
      await _localStore.put(_bookingsBox, updated.id, _bookingToJson(updated));
      return Result.ok(updated);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Exception?> _validateCapacity(BookingDraft draft) async {
    if (draft.workshopId == null) {
      return Exception('Draft belum memiliki bengkel.');
    }
    final workshopId = draft.workshopId!;

    if (draft.scheduleMode == ScheduleMode.shared) {
      final sharedSlot = draft.sharedSlot;
      if (sharedSlot == null) {
        return Exception('Draft belum memiliki jadwal.');
      }
      final freshBooked = await _slotOccupancy.bookedCount(
        localStore: _localStore,
        workshopId: workshopId,
        date: sharedSlot.date,
        hour: sharedSlot.hour,
        capacity: _capacity,
      );
      final freshSlot = TimeSlot(
        date: sharedSlot.date,
        hour: sharedSlot.hour,
        capacity: _capacity,
        booked: freshBooked,
      );
      if (!_slotCapacityService.hasSharedCapacityFor(
        slot: freshSlot,
        unitCount: draft.selectedMotorIds.length,
      )) {
        return Exception('Slot penuh, silakan pilih jam lain.');
      }
      return null;
    }

    final byKey = <String, List<String>>{};
    for (final motorId in draft.selectedMotorIds) {
      final slot = draft.unitSlots[motorId];
      if (slot == null) {
        return Exception('Draft belum memiliki jadwal untuk salah satu motor.');
      }
      byKey.putIfAbsent(_slotKey(slot), () => []).add(motorId);
    }
    for (final group in byKey.values) {
      final slot = draft.unitSlots[group.first]!;
      final freshBooked = await _slotOccupancy.bookedCount(
        localStore: _localStore,
        workshopId: workshopId,
        date: slot.date,
        hour: slot.hour,
        capacity: _capacity,
      );
      for (var i = 0; i < group.length; i++) {
        final freshSlot = TimeSlot(
          date: slot.date,
          hour: slot.hour,
          capacity: _capacity,
          booked: freshBooked,
        );
        if (!_slotCapacityService.canSplitPlaceUnit(
          slot: freshSlot,
          siblingsAlreadyPlaced: i,
        )) {
          return Exception('Slot penuh, silakan pilih jam lain.');
        }
      }
    }
    return null;
  }

  String _slotKey(TimeSlot slot) =>
      '${slot.date.year}-${slot.date.month}-${slot.date.day}|${slot.hour}';

  String _formatSlot(TimeSlot slot) {
    final date =
        '${slot.date.year}-${slot.date.month.toString().padLeft(2, '0')}-'
        '${slot.date.day.toString().padLeft(2, '0')}';
    return '$date ${slot.hour.toString().padLeft(2, '0')}:00';
  }

  T? _find<T>(List<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  Future<void> _ensureSeeded() async {
    final existing = await _localStore.getAll(_bookingsBox);
    if (existing.isNotEmpty) return;
    final json =
        await _mockJsonLoader.load('bookings_seed.json') as List<dynamic>;
    for (final row in json.cast<Map<String, dynamic>>()) {
      await _localStore.put(_bookingsBox, row['id'] as String, row);
    }
  }

  Future<void> _ensureCountersSeeded() async {
    final existing = await _localStore.getAll(_counterBox);
    if (existing.isNotEmpty) return;
    final json =
        await _mockJsonLoader.load('bookings_seed.json') as List<dynamic>;
    final counters = <String, int>{};
    for (final row in json.cast<Map<String, dynamic>>()) {
      final code = row['code'] as String;
      final parts = code.split('-');
      final yymmdd = parts[1];
      final n = int.parse(parts[2]);
      final current = counters[yymmdd];
      if (current == null || n > current) counters[yymmdd] = n;
    }
    // The canonical live-demo booking TS-260929-0417 is deliberately not
    // seeded (it's created by walking through the S10->S18 flow), so this
    // date's counter is pre-seeded one below it.
    counters['260929'] = 416;
    for (final entry in counters.entries) {
      await _localStore.put(_counterBox, entry.key, {'last': entry.value});
    }
  }

  Future<String> _nextCode(DateTime referenceDate) async {
    await _ensureCountersSeeded();
    final yymmdd = _formatYyMmDd(referenceDate);
    final row = await _localStore.get(_counterBox, yymmdd);
    final next = ((row?['last'] as int?) ?? 0) + 1;
    await _localStore.put(_counterBox, yymmdd, {'last': next});
    return 'TS-$yymmdd-${next.toString().padLeft(4, '0')}';
  }

  String _formatYyMmDd(DateTime date) {
    final yy = (date.year % 100).toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '$yy$mm$dd';
  }

  Booking _bookingFromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    code: json['code'] as String,
    userId: json['user_id'] as String,
    workshopId: json['workshop_id'] as String,
    units: (json['units'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_bookingUnitFromJson)
        .toList(),
    scheduleMode: ScheduleModeX.fromString(json['schedule_mode'] as String?),
    sharedSlot: json['shared_slot'] == null
        ? null
        : _timeSlotFromJson(json['shared_slot'] as Map<String, dynamic>),
    unitSlots: json['unit_slots'] == null
        ? null
        : (json['unit_slots'] as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, _timeSlotFromJson(v as Map<String, dynamic>)),
          ),
    status: BookingStatusX.fromString(json['status'] as String?),
    voucherId: json['voucher_id'] as String?,
    subtotal: json['subtotal'] as int,
    discount: json['discount'] as int,
    total: json['total'] as int,
    createdAt: DateTime.parse(json['created_at'] as String),
    completedAt: json['completed_at'] == null
        ? null
        : DateTime.parse(json['completed_at'] as String),
  );

  Map<String, dynamic> _bookingToJson(Booking booking) => {
    'id': booking.id,
    'code': booking.code,
    'user_id': booking.userId,
    'workshop_id': booking.workshopId,
    'units': booking.units.map(_bookingUnitToJson).toList(),
    'schedule_mode': booking.scheduleMode.name,
    'shared_slot': booking.sharedSlot == null
        ? null
        : _timeSlotToJson(booking.sharedSlot!),
    'unit_slots': booking.unitSlots?.map(
      (k, v) => MapEntry(k, _timeSlotToJson(v)),
    ),
    'status': booking.status.name,
    'voucher_id': booking.voucherId,
    'subtotal': booking.subtotal,
    'discount': booking.discount,
    'total': booking.total,
    'created_at': booking.createdAt.toIso8601String(),
    'completed_at': booking.completedAt?.toIso8601String(),
  };

  BookingUnit _bookingUnitFromJson(Map<String, dynamic> json) => BookingUnit(
    unitCode: json['unit_code'] as String,
    motorId: json['motor_id'] as String,
    motorSnapshot: _motorSnapshotFromJson(
      json['motor_snapshot'] as Map<String, dynamic>,
    ),
    serviceIds: (json['service_ids'] as List<dynamic>).cast<String>(),
    partIds: (json['part_ids'] as List<dynamic>).cast<String>(),
    complaintNote: json['complaint_note'] as String?,
    status: UnitStatusX.fromString(json['status'] as String?),
    statusHistory: (json['status_history'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_statusEventFromJson)
        .toList(),
    mechanicId: json['mechanic_id'] as String?,
    subtotal: json['subtotal'] as int,
    durationMin: json['duration_min'] as int,
  );

  Map<String, dynamic> _bookingUnitToJson(BookingUnit unit) => {
    'unit_code': unit.unitCode,
    'motor_id': unit.motorId,
    'motor_snapshot': _motorSnapshotToJson(unit.motorSnapshot),
    'service_ids': unit.serviceIds,
    'part_ids': unit.partIds,
    if (unit.complaintNote != null) 'complaint_note': unit.complaintNote,
    'status': unit.status.name,
    'status_history': unit.statusHistory.map(_statusEventToJson).toList(),
    if (unit.mechanicId != null) 'mechanic_id': unit.mechanicId,
    'subtotal': unit.subtotal,
    'duration_min': unit.durationMin,
  };

  StatusEvent _statusEventFromJson(Map<String, dynamic> json) => StatusEvent(
    status: UnitStatusX.fromString(json['status'] as String?),
    timestamp: DateTime.parse(json['timestamp'] as String),
    note: json['note'] as String?,
  );

  Map<String, dynamic> _statusEventToJson(StatusEvent event) => {
    'status': event.status.name,
    'timestamp': event.timestamp.toIso8601String(),
    if (event.note != null) 'note': event.note,
  };

  TimeSlot _timeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
    date: DateTime.parse(json['date'] as String),
    hour: json['hour'] as int,
    capacity: json['capacity'] as int,
    booked: json['booked'] as int,
  );

  Map<String, dynamic> _timeSlotToJson(TimeSlot slot) => {
    'date': slot.date.toIso8601String(),
    'hour': slot.hour,
    'capacity': slot.capacity,
    'booked': slot.booked,
  };

  Motor _motorSnapshotFromJson(Map<String, dynamic> json) => Motor(
    id: json['id'] as String,
    ownerId: json['owner_id'] as String,
    nickname: json['nickname'] as String,
    plateNumber: json['plate_number'] as String,
    year: json['year'] as int?,
    photoUrl: json['photo_url'] as String?,
    modelId: json['model_id'] as String,
  );

  Map<String, dynamic> _motorSnapshotToJson(Motor motor) => {
    'id': motor.id,
    'owner_id': motor.ownerId,
    'nickname': motor.nickname,
    'plate_number': motor.plateNumber,
    'year': motor.year,
    'photo_url': motor.photoUrl,
    'model_id': motor.modelId,
  };

  BookingDraft _draftFromJson(Map<String, dynamic> json) => BookingDraft(
    id: json['id'] as String,
    selectedMotorIds: (json['selected_motor_ids'] as List<dynamic>)
        .cast<String>(),
    unitConfigs: (json['unit_configs'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, _unitConfigFromJson(v as Map<String, dynamic>)),
    ),
    workshopId: json['workshop_id'] as String?,
    scheduleMode: ScheduleModeX.fromString(json['schedule_mode'] as String?),
    sharedSlot: json['shared_slot'] == null
        ? null
        : _timeSlotFromJson(json['shared_slot'] as Map<String, dynamic>),
    unitSlots: (json['unit_slots'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, _timeSlotFromJson(v as Map<String, dynamic>)),
    ),
    voucherId: json['voucher_id'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    expiresAt: DateTime.parse(json['expires_at'] as String),
  );

  Map<String, dynamic> _draftToJson(BookingDraft draft) => {
    'id': draft.id,
    'selected_motor_ids': draft.selectedMotorIds,
    'unit_configs': draft.unitConfigs.map(
      (k, v) => MapEntry(k, _unitConfigToJson(v)),
    ),
    'workshop_id': draft.workshopId,
    'schedule_mode': draft.scheduleMode.name,
    'shared_slot': draft.sharedSlot == null
        ? null
        : _timeSlotToJson(draft.sharedSlot!),
    'unit_slots': draft.unitSlots.map(
      (k, v) => MapEntry(k, _timeSlotToJson(v)),
    ),
    'voucher_id': draft.voucherId,
    'created_at': draft.createdAt.toIso8601String(),
    'expires_at': draft.expiresAt.toIso8601String(),
  };

  UnitConfig _unitConfigFromJson(Map<String, dynamic> json) => UnitConfig(
    serviceIds: (json['service_ids'] as List<dynamic>).cast<String>(),
    partIds: (json['part_ids'] as List<dynamic>).cast<String>(),
    complaintNote: json['complaint_note'] as String?,
  );

  Map<String, dynamic> _unitConfigToJson(UnitConfig config) => {
    'service_ids': config.serviceIds,
    'part_ids': config.partIds,
    if (config.complaintNote != null) 'complaint_note': config.complaintNote,
  };
}
