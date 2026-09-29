// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/data/service/slot_occupancy_calculator.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/mechanic.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/repository/workshop/workshop_repository.dart';
import 'package:tumbas_servis/core/domain/service/clock.dart';

class WorkshopRepositoryImpl implements WorkshopRepository {
  WorkshopRepositoryImpl({
    required MockJsonLoader mockJsonLoader,
    required LatencySimulator latencySimulator,
    required Clock clock,
    required LocalStore localStore,
  }) : _mockJsonLoader = mockJsonLoader,
       _latencySimulator = latencySimulator,
       _clock = clock,
       _localStore = localStore;

  final MockJsonLoader _mockJsonLoader;
  final LatencySimulator _latencySimulator;
  final Clock _clock;
  final LocalStore _localStore;

  static const _slotOccupancy = SlotOccupancyCalculator();
  static const _capacity = 5;
  static const _hours = [8, 9, 10, 11, 12, 13, 14, 15, 16];

  @override
  Future<Result<List<Workshop>>> getWorkshops({
    bool openNowOnly = false,
  }) async {
    try {
      await _latencySimulator.simulate();
      final workshops = await _loadWorkshops();
      final now = _clock.now();
      final filtered = openNowOnly
          ? workshops.where((w) => _isOpenNow(w, now)).toList()
          : workshops;
      filtered.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      return Result.ok(filtered);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<Workshop>> getWorkshop(String id) async {
    try {
      await _latencySimulator.simulate();
      final workshops = await _loadWorkshops();
      final workshop = _findWorkshop(workshops, id);
      if (workshop == null) {
        return Result.error(Exception('Workshop not found: $id'));
      }
      return Result.ok(workshop);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Mechanic>>> getMechanics() async {
    try {
      await _latencySimulator.simulate();
      final json =
          await _mockJsonLoader.load('mechanics.json') as List<dynamic>;
      return Result.ok(
        json
            .cast<Map<String, dynamic>>()
            .map(
              (m) => Mechanic(
                id: m['id'] as String,
                name: m['name'] as String,
                avatarInitial: m['avatar_initial'] as String,
                rating: (m['rating'] as num).toDouble(),
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<TimeSlot>>> getAvailableSlots({
    required String workshopId,
    required DateTime date,
  }) async {
    try {
      await _latencySimulator.simulate();
      final workshops = await _loadWorkshops();
      if (_findWorkshop(workshops, workshopId) == null) {
        return Result.error(Exception('Workshop not found: $workshopId'));
      }
      final slots = <TimeSlot>[];
      for (final hour in _hours) {
        final booked = await _slotOccupancy.bookedCount(
          localStore: _localStore,
          workshopId: workshopId,
          date: date,
          hour: hour,
          capacity: _capacity,
        );
        slots.add(
          TimeSlot(date: date, hour: hour, capacity: _capacity, booked: booked),
        );
      }
      return Result.ok(slots);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  Workshop? _findWorkshop(List<Workshop> workshops, String id) {
    for (final workshop in workshops) {
      if (workshop.id == id) return workshop;
    }
    return null;
  }

  Future<List<Workshop>> _loadWorkshops() async {
    final json = await _mockJsonLoader.load('workshops.json') as List<dynamic>;
    return json.cast<Map<String, dynamic>>().map(_workshopFromJson).toList();
  }

  bool _isOpenNow(Workshop workshop, DateTime now) =>
      now.hour >= workshop.openTime && now.hour < workshop.closeTime;

  Workshop _workshopFromJson(Map<String, dynamic> json) => Workshop(
    id: json['id'] as String,
    name: json['name'] as String,
    rating: (json['rating'] as num).toDouble(),
    reviewCount: json['review_count'] as int,
    distanceKm: (json['distance_km'] as num).toDouble(),
    address: json['address'] as String,
    openTime: json['open_time'] as int,
    closeTime: json['close_time'] as int,
    bayCount: json['bay_count'] as int,
    staticMapAssetPath: json['static_map_asset_path'] as String,
    serviceIds: (json['service_ids'] as List<dynamic>).cast<String>(),
  );
}
