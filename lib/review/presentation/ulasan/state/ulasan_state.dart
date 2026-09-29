import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';

part 'ulasan_state.freezed.dart';

@freezed
abstract class MechanicRatingItem with _$MechanicRatingItem {
  const factory MechanicRatingItem({
    required String mechanicId,
    required String name,
    required String initial,
    required String unitsLabel,
  }) = _MechanicRatingItem;
}

@freezed
abstract class UlasanState with _$UlasanState {
  const factory UlasanState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default(false) bool blockedUnpaid,
    @Default('') String workshopName,
    @Default(<MechanicRatingItem>[]) List<MechanicRatingItem> mechanics,
    @Default(0) int workshopRating,
    @Default(<String, int>{}) Map<String, int> mechanicRatings,
    @Default('') String comment,
    @Default(false) bool ratingError,
    @Default(false) bool isSubmitting,
    Review? submitted,
  }) = _UlasanState;

  const UlasanState._();

  static const ratingRequired = 'Pilih bintang untuk bengkel';
  static const unpaidReason = 'Tandai lunas di invoice dulu';

  bool get showMechanicSection => mechanics.length >= 2;

  bool get isSubmitted => submitted != null;

  bool get isReady => !isLoading && !hasError;
}
