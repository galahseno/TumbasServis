import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_type.freezed.dart';

@freezed
abstract class ServiceType with _$ServiceType {
  const factory ServiceType({
    required String id,
    required String name,
    required int price,
    required int durationMin,
    required bool requiresComplaint,
  }) = _ServiceType;
}
