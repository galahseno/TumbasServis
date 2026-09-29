// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/domain/repository/invoice/invoice_repository.dart';
import 'package:tumbas_servis/core/domain/repository/review/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({
    required LocalStore localStore,
    required LatencySimulator latencySimulator,
    required InvoiceRepository invoiceRepository,
    required DemoModeController demoModeController,
  }) : _localStore = localStore,
       _latencySimulator = latencySimulator,
       _invoiceRepository = invoiceRepository,
       _demoModeController = demoModeController;

  final LocalStore _localStore;
  final LatencySimulator _latencySimulator;
  final InvoiceRepository _invoiceRepository;
  final DemoModeController _demoModeController;

  static const _reviewsBox = 'reviews';

  @override
  Future<Result<void>> submitReview(Review review) async {
    try {
      await _latencySimulator.simulate();
      if (_demoModeController.consumeArmedError()) {
        return Result.error(Exception('Simulated network error.'));
      }
      if (!review.isWorkshopCommentValid) {
        return Result.error(Exception('Komentar melebihi 300 karakter.'));
      }
      final invoiceResult = await _invoiceRepository.getInvoice(
        review.bookingId,
      );
      if (invoiceResult is Error<Invoice>) {
        return Result.error(invoiceResult.error);
      }
      final invoice = (invoiceResult as Ok<Invoice>).value;
      if (!invoice.isPaid) {
        return Result.error(
          Exception(
            'Tandai lunas invoice terlebih dahulu sebelum memberi ulasan.',
          ),
        );
      }
      await _localStore.put(
        _reviewsBox,
        review.bookingId,
        _reviewToJson(review),
      );
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<Review?>> getReview(String bookingId) async {
    try {
      await _latencySimulator.simulate();
      final row = await _localStore.get(_reviewsBox, bookingId);
      return Result.ok(row == null ? null : _reviewFromJson(row));
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  Review _reviewFromJson(Map<String, dynamic> json) => Review(
    bookingId: json['booking_id'] as String,
    workshopRating: json['workshop_rating'] as int,
    workshopComment: json['workshop_comment'] as String?,
    mechanicRatings: (json['mechanic_ratings'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, v as int),
    ),
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> _reviewToJson(Review review) => {
    'booking_id': review.bookingId,
    'workshop_rating': review.workshopRating,
    'workshop_comment': review.workshopComment,
    'mechanic_ratings': review.mechanicRatings,
    'created_at': review.createdAt.toIso8601String(),
  };
}
