import 'package:freezed_annotation/freezed_annotation.dart';

part 'workshop.freezed.dart';

@freezed
abstract class Workshop with _$Workshop {
  const factory Workshop({
    required String id,
    required String name,
    required double rating,
    required int reviewCount,
    required double distanceKm,
    required String address,
    required int openTime,
    required int closeTime,
    required int bayCount,
    required String staticMapAssetPath,
    required List<String> serviceIds,
  }) = _Workshop;
}
