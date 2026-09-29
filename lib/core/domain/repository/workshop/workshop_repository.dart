import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/mechanic.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';

abstract class WorkshopRepository {
  Future<Result<List<Workshop>>> getWorkshops({bool openNowOnly = false});
  Future<Result<Workshop>> getWorkshop(String id);
  Future<Result<List<Mechanic>>> getMechanics();
  Future<Result<List<TimeSlot>>> getAvailableSlots({
    required String workshopId,
    required DateTime date,
  });
}
