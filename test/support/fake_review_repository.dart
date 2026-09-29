import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/domain/repository/review/review_repository.dart';

class FakeReviewRepository implements ReviewRepository {
  Review? review;

  @override
  Future<Result<void>> submitReview(Review value) async {
    review = value;
    return const Result.ok(null);
  }

  @override
  Future<Result<Review?>> getReview(String bookingId) async =>
      Result.ok(review);
}
