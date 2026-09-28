// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/data/service/tracking_status_writer.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/booking/booking_repository.dart';
import 'package:tumbas_servis/core/domain/repository/tracking/tracking_repository.dart';
import 'package:tumbas_servis/core/domain/service/clock.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  TrackingRepositoryImpl({
    required TrackingSimulator trackingSimulator,
    required LocalStore localStore,
    required LatencySimulator latencySimulator,
    required Clock clock,
    required BookingRepository bookingRepository,
  }) : _trackingSimulator = trackingSimulator,
       _localStore = localStore,
       _latencySimulator = latencySimulator,
       _clock = clock,
       _bookingRepository = bookingRepository;

  final TrackingSimulator _trackingSimulator;
  final LocalStore _localStore;
  final LatencySimulator _latencySimulator;
  final Clock _clock;
  final BookingRepository _bookingRepository;

  static const _statusWriter = TrackingStatusWriter();

  @override
  Stream<BookingUnit> watchUnitStatus({
    required String bookingId,
    required String unitCode,
  }) {
    late final StreamController<BookingUnit> controller;
    StreamSubscription<UnitStatus>? subscription;

    controller = StreamController<BookingUnit>(
      onListen: () {
        unawaited(
          _findUnit(bookingId, unitCode).then((initial) {
            if (initial != null && !controller.isClosed) {
              controller.add(initial);
            }
          }),
        );
        subscription = _trackingSimulator.watch(bookingId, unitCode).listen((
          status,
        ) {
          unawaited(
            _findUnit(bookingId, unitCode).then((unit) {
              if (unit != null && !controller.isClosed) {
                controller.add(unit.copyWith(status: status));
              }
            }),
          );
        });
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  @override
  Future<Result<void>> advanceUnitStatus({
    required String bookingId,
    required String unitCode,
  }) async {
    try {
      await _latencySimulator.simulate();
      final unit = await _findUnit(bookingId, unitCode);
      if (unit == null) {
        return Result.error(Exception('Unit tidak ditemukan: $unitCode'));
      }
      if (unit.status.isTerminal) {
        return Result.error(Exception('Unit ini sudah dalam status akhir.'));
      }
      _trackingSimulator.advance(bookingId, unitCode);
      final newStatus = _trackingSimulator.currentStatus(bookingId, unitCode);
      await _statusWriter.writeAdvance(
        localStore: _localStore,
        clock: _clock,
        bookingId: bookingId,
        unitCode: unitCode,
        status: newStatus,
      );
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> resetUnitStatus({
    required String bookingId,
    required String unitCode,
  }) async {
    try {
      await _latencySimulator.simulate();
      _trackingSimulator.reset(bookingId, unitCode);
      await _statusWriter.writeReset(
        localStore: _localStore,
        clock: _clock,
        bookingId: bookingId,
        unitCode: unitCode,
      );
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<BookingUnit?> _findUnit(String bookingId, String unitCode) async {
    final result = await _bookingRepository.getBooking(bookingId);
    return switch (result) {
      Ok(:final value) => _unitInList(value.units, unitCode),
      Error() => null,
    };
  }

  BookingUnit? _unitInList(List<BookingUnit> units, String unitCode) {
    for (final unit in units) {
      if (unit.unitCode == unitCode) return unit;
    }
    return null;
  }
}
