import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/repository/workshop/workshop_repository.dart';

class FakeWorkshopRepository implements WorkshopRepository {
  Result<List<Workshop>> workshopsResult = const Result.ok([]);

  @override
  Future<Result<List<Workshop>>> getWorkshops({
    bool openNowOnly = false,
  }) async => workshopsResult;

  @override
  Future<Result<Workshop>> getWorkshop(String id) async =>
      throw UnimplementedError();

  @override
  Future<Result<List<TimeSlot>>> getAvailableSlots({
    required String workshopId,
    required DateTime date,
  }) async => throw UnimplementedError();
}
