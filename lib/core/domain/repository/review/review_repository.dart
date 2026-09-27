import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';

abstract class ReviewRepository {
  Future<Result<void>> submitReview(Review review);
  Future<Result<Review?>> getReview(String bookingId);
}
