import 'dart:async';

import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/tracking/tracking_repository.dart';

class FakeTrackingRepository implements TrackingRepository {
  final Map<String, StreamController<BookingUnit>> _controllers = {};

  Result<void> advanceResult = const Result.ok(null);
  Result<void> resetResult = const Result.ok(null);
  final List<({String bookingId, String unitCode})> advanceCalls = [];
  final List<({String bookingId, String unitCode})> resetCalls = [];

  StreamController<BookingUnit> _controllerFor(
    String bookingId,
    String unitCode,
  ) => _controllers.putIfAbsent(
    '$bookingId|$unitCode',
    () => StreamController<BookingUnit>.broadcast(sync: true),
  );

  /// Pushes a live update to whoever watches [unit].
  void emit(String bookingId, BookingUnit unit) =>
      _controllerFor(bookingId, unit.unitCode).add(unit);

  bool isWatched(String bookingId, String unitCode) =>
      _controllers['$bookingId|$unitCode']?.hasListener ?? false;

  @override
  Stream<BookingUnit> watchUnitStatus({
    required String bookingId,
    required String unitCode,
  }) => _controllerFor(bookingId, unitCode).stream;

  @override
  Future<Result<void>> advanceUnitStatus({
    required String bookingId,
    required String unitCode,
  }) async {
    advanceCalls.add((bookingId: bookingId, unitCode: unitCode));
    return advanceResult;
  }

  @override
  Future<Result<void>> resetUnitStatus({
    required String bookingId,
    required String unitCode,
  }) async {
    resetCalls.add((bookingId: bookingId, unitCode: unitCode));
    return resetResult;
  }
}
