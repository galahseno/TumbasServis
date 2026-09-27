import 'package:freezed_annotation/freezed_annotation.dart';

part 'part.freezed.dart';

@freezed
abstract class Part with _$Part {
  const factory Part({
    required String id,
    required String name,
    required String category,
    required String brand,
    required String grade,
    required int price,
    required List<String> compatibleModelIds,
  }) = _Part;
}
