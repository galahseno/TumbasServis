import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/repository/workshop/workshop_repository.dart';

class FakeWorkshopRepository implements WorkshopRepository {
  Result<List<Workshop>> workshopsResult = const Result.ok([]);
  Result<Workshop>? workshopResult;
  Result<List<TimeSlot>> availableSlotsResult = const Result.ok([]);
  List<bool> openNowOnlyCalls = [];

  @override
  Future<Result<List<Workshop>>> getWorkshops({
    bool openNowOnly = false,
  }) async {
    openNowOnlyCalls.add(openNowOnly);
    return workshopsResult;
  }

  @override
  Future<Result<Workshop>> getWorkshop(String id) async {
    if (workshopResult != null) return workshopResult!;
    final workshops = switch (workshopsResult) {
      Ok<List<Workshop>>(value: final value) => value,
      Error<List<Workshop>>() => const <Workshop>[],
    };
    for (final workshop in workshops) {
      if (workshop.id == id) return Result.ok(workshop);
    }
    return Result.error(Exception('Workshop not found: $id'));
  }

  @override
  Future<Result<List<TimeSlot>>> getAvailableSlots({
    required String workshopId,
    required DateTime date,
  }) async => availableSlotsResult;
}
