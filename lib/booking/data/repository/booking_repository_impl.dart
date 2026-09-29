// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/booking/data/mapper/booking_draft_mapper.dart';
import 'package:tumbas_servis/booking/data/mapper/booking_mapper.dart';
import 'package:tumbas_servis/booking/data/util/booking_code_generator.dart';
import 'package:tumbas_servis/booking/data/util/slot_capacity_validator.dart';
import 'package:tumbas_servis/booking/data/util/time_slot_format.dart';
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
       _sessionRepository = sessionRepository,
       _codeGenerator = BookingCodeGenerator(
         localStore: localStore,
         mockJsonLoader: mockJsonLoader,
       ),
       _capacityValidator = SlotCapacityValidator(localStore: localStore);

  final LocalStore _localStore;
  final MockJsonLoader _mockJsonLoader;
  final LatencySimulator _latencySimulator;
  final Clock _clock;
  final CatalogRepository _catalogRepository;
  final GarageRepository _garageRepository;
  final SessionRepository _sessionRepository;
  final BookingCodeGenerator _codeGenerator;
  final SlotCapacityValidator _capacityValidator;

  static const _bookingsBox = SlotOccupancyCalculator.bookingsBox;
  static const _draftBox = 'booking_drafts';
  static const _draftKey = 'current';
  static const _unitCodeSuffixes = ['-A', '-B', '-C', '-D', '-E'];

  static const _pricingCalculator = PricingCalculator();
  static const _fleetDurationCalculator = FleetDurationCalculator();
  static const _voucherEligibilityService = VoucherEligibilityService();
  static const _statusDerivation = BookingStatusDerivation();

  @override
  Future<Result<BookingDraft>> createDraft() async {
    try {
      await _latencySimulator.simulate();
      final now = _clock.now();
      final existing = await _localStore.get(_draftBox, _draftKey);
      if (existing != null) {
        final draft = existing.toBookingDraft();
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
      await _localStore.put(_draftBox, _draftKey, draft.toDraftJson());
      return Result.ok(draft);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<BookingDraft?>> getCurrentDraft() async {
    try {
      await _latencySimulator.simulate();
      final existing = await _localStore.get(_draftBox, _draftKey);
      if (existing == null) return const Result.ok(null);
      final draft = existing.toBookingDraft();
      if (_clock.now().isBefore(draft.expiresAt)) {
        return Result.ok(draft);
      }
      return const Result.ok(null);
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
      await _localStore.put(_draftBox, _draftKey, draft.toDraftJson());
      return Result.ok(draft);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteDraft() async {
    try {
      await _latencySimulator.simulate();
      await _localStore.delete(_draftBox, _draftKey);
      return const Result.ok(null);
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

      final capacityError = await _capacityValidator.validateDraft(draft);
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
      final code = await _codeGenerator.next(referenceDate);

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

      await _localStore.put(_bookingsBox, booking.id, booking.toBookingJson());
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
          .map((row) => row.toBooking())
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
      return Result.ok(row.toBooking());
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> cancelBooking(
    String id, {
    String? unitCode,
    String? reason,
  }) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      final row = await _localStore.get(_bookingsBox, id);
      if (row == null) {
        return Result.error(Exception('Booking not found: $id'));
      }
      final booking = row.toBooking();
      final now = _clock.now();
      final cancelNote = (reason == null || reason.trim().isEmpty)
          ? 'Dibatalkan oleh pengguna.'
          : 'Dibatalkan oleh pengguna: ${reason.trim()}';

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
                    note: cancelNote,
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
                          note: cancelNote,
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
        updatedBooking.toBookingJson(),
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
      final booking = row.toBooking();
      final now = _clock.now();

      if (booking.scheduleMode == ScheduleMode.shared) {
        if (newSharedSlot == null) {
          return Result.error(
            Exception(
              'newSharedSlot is required to reschedule a shared-mode booking.',
            ),
          );
        }

        final activeUnits = booking.units
            .where((u) => u.status != UnitStatus.dibatalkan)
            .toList();
        if (activeUnits.isEmpty ||
            activeUnits.any((u) => u.status != UnitStatus.terjadwal)) {
          return Result.error(
            Exception('Booking ini sudah tidak bisa dijadwal ulang.'),
          );
        }
        if (!await _capacityValidator.hasSharedCapacityFor(
          workshopId: booking.workshopId,
          slot: newSharedSlot,
          unitCount: activeUnits.length,
        )) {
          return Result.error(Exception('Slot penuh, silakan pilih jam lain.'));
        }
        final updatedUnits = booking.units
            .map(
              (u) => u.status == UnitStatus.dibatalkan
                  ? u
                  : u.copyWith(
                      statusHistory: [
                        ...u.statusHistory,
                        StatusEvent(
                          status: UnitStatus.terjadwal,
                          timestamp: now,
                          note:
                              'Dijadwal ulang ke ${newSharedSlot.auditLabel}.',
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
          updated.toBookingJson(),
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
      if (!await _capacityValidator.canPlaceUnits(
        workshopId: booking.workshopId,
        slots: newUnitSlots,
      )) {
        return Result.error(Exception('Slot penuh, silakan pilih jam lain.'));
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
              note: 'Dijadwal ulang ke ${newSlot.auditLabel}.',
            ),
          ],
        );
      }).toList();
      final updated = booking.copyWith(
        unitSlots: updatedUnitSlots,
        units: updatedUnits,
      );
      await _localStore.put(_bookingsBox, updated.id, updated.toBookingJson());
      return Result.ok(updated);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  T? _find<T>(List<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  Future<void>? _seeding;

  Future<void> _ensureSeeded() =>
      _seeding ??= _seedIfEmpty().whenComplete(() => _seeding = null);

  Future<void> _seedIfEmpty() async {
    final existing = await _localStore.getAll(_bookingsBox);
    if (existing.isNotEmpty) return;
    final json =
        await _mockJsonLoader.load('bookings_seed.json') as List<dynamic>;
    for (final row in json.cast<Map<String, dynamic>>()) {
      await _localStore.put(_bookingsBox, row['id'] as String, row);
    }
  }
}
