import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/repository/booking/booking_repository.dart';

class FakeBookingRepository implements BookingRepository {
  Result<List<Booking>> bookingsResult = const Result.ok([]);
  Result<BookingDraft?> currentDraftResult = const Result.ok(null);
  Result<BookingDraft>? createDraftResult;
  bool draftDeleted = false;
  BookingDraft? lastUpdatedDraft;
  List<BookingDraft> updateDraftCalls = [];
  Result<Booking>? confirmBookingResult;
  List<BookingDraft> confirmBookingCalls = [];

  @override
  Future<Result<List<Booking>>> getBookings({BookingStatus? status}) async =>
      bookingsResult;

  @override
  Future<Result<BookingDraft?>> getCurrentDraft() async => currentDraftResult;

  @override
  Future<Result<void>> deleteDraft() async {
    draftDeleted = true;
    return const Result.ok(null);
  }

  @override
  Future<Result<BookingDraft>> createDraft() async =>
      createDraftResult ?? (throw UnimplementedError());

  @override
  Future<Result<BookingDraft>> updateDraft(BookingDraft draft) async {
    lastUpdatedDraft = draft;
    updateDraftCalls.add(draft);
    return Result.ok(draft);
  }

  @override
  Future<Result<Booking>> confirmBooking(BookingDraft draft) async {
    confirmBookingCalls.add(draft);
    return confirmBookingResult ?? (throw UnimplementedError());
  }

  @override
  Future<Result<Booking>> getBooking(String id) async =>
      throw UnimplementedError();

  @override
  Future<Result<void>> cancelBooking(String id, {String? unitCode}) async =>
      throw UnimplementedError();

  @override
  Future<Result<Booking>> rescheduleBooking({
    required String id,
    TimeSlot? newSharedSlot,
    Map<String, TimeSlot>? newUnitSlots,
  }) async => throw UnimplementedError();
}
