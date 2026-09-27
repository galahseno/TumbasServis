import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

abstract class TrackingRepository {
  Stream<BookingUnit> watchUnitStatus({
    required String bookingId,
    required String unitCode,
  });
  Future<Result<void>> advanceUnitStatus({
    required String bookingId,
    required String unitCode,
  });
  Future<Result<void>> resetUnitStatus({
    required String bookingId,
    required String unitCode,
  });
}
