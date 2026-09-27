import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo.freezed.dart';

@freezed
abstract class Promo with _$Promo {
  const factory Promo({
    required String id,
    required String title,
    required String imageAssetPath,
    String? deepLink,
  }) = _Promo;
}
