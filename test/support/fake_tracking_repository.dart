import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/tracking/tracking_repository.dart';

class FakeTrackingRepository implements TrackingRepository {
  @override
  Stream<BookingUnit> watchUnitStatus({
    required String bookingId,
    required String unitCode,
  }) => const Stream.empty();

  @override
  Future<Result<void>> advanceUnitStatus({
    required String bookingId,
    required String unitCode,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> resetUnitStatus({
    required String bookingId,
    required String unitCode,
  }) async => const Result.ok(null);
}
