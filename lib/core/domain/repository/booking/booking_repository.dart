import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

abstract class BookingRepository {
  Future<Result<BookingDraft>> createDraft();
  Future<Result<BookingDraft?>> getCurrentDraft();
  Future<Result<BookingDraft>> updateDraft(BookingDraft draft);
  Future<Result<void>> deleteDraft();
  Future<Result<Booking>> confirmBooking(BookingDraft draft);
  Future<Result<List<Booking>>> getBookings({BookingStatus? status});
  Future<Result<Booking>> getBooking(String id);
  Future<Result<void>> cancelBooking(String id, {String? unitCode});
  Future<Result<Booking>> rescheduleBooking({
    required String id,
    TimeSlot? newSharedSlot,
    Map<String, TimeSlot>? newUnitSlots,
  });
}
