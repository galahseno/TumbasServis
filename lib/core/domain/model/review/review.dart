import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';

@freezed
abstract class Review with _$Review {
  const Review._();

  const factory Review({
    required String bookingId,
    required int workshopRating,
    String? workshopComment,
    required Map<String, int> mechanicRatings,
    required DateTime createdAt,
  }) = _Review;

  static const int workshopCommentMaxLength = 300;

  bool get isWorkshopCommentValid =>
      workshopComment == null ||
      workshopComment!.length <= workshopCommentMaxLength;
}
