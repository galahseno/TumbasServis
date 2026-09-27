import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';

void main() {
  group('Review.isWorkshopCommentValid', () {
    final createdAt = DateTime(2026, 9, 27);

    test('accepts a null comment', () {
      final review = Review(
        bookingId: 'b1',
        workshopRating: 5,
        mechanicRatings: const {},
        createdAt: createdAt,
      );

      expect(review.isWorkshopCommentValid, isTrue);
    });

    test('accepts comment exactly at the 300-char boundary', () {
      final review = Review(
        bookingId: 'b1',
        workshopRating: 5,
        workshopComment: 'x' * Review.workshopCommentMaxLength,
        mechanicRatings: const {},
        createdAt: createdAt,
      );

      expect(review.isWorkshopCommentValid, isTrue);
    });

    test('rejects comment over the 300-char boundary', () {
      final review = Review(
        bookingId: 'b1',
        workshopRating: 5,
        workshopComment: 'x' * (Review.workshopCommentMaxLength + 1),
        mechanicRatings: const {},
        createdAt: createdAt,
      );

      expect(review.isWorkshopCommentValid, isFalse);
    });
  });
}
