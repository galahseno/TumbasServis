import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/domain/model/workshop/mechanic.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/review/presentation/ulasan/state/ulasan_state.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

class UlasanViewModel extends Notifier<UlasanState> {
  UlasanViewModel(this.bookingId);

  final String bookingId;

  @override
  UlasanState build() {
    _load();
    return const UlasanState();
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  void setWorkshopRating(int value) {
    if (state.isSubmitting || state.isSubmitted) return;
    state = state.copyWith(
      workshopRating: value.clamp(1, 5),
      ratingError: false,
    );
  }

  void setMechanicRating(String mechanicId, int value) {
    if (state.isSubmitting || state.isSubmitted) return;
    final ratings = Map<String, int>.of(state.mechanicRatings);
    if (ratings[mechanicId] == value) {
      ratings.remove(mechanicId);
    } else {
      ratings[mechanicId] = value.clamp(1, 5);
    }
    state = state.copyWith(mechanicRatings: ratings);
  }

  void setComment(String value) {
    if (state.isSubmitting || state.isSubmitted) return;
    final max = Review.workshopCommentMaxLength;
    state = state.copyWith(
      comment: value.length > max ? value.substring(0, max) : value,
    );
  }

  Future<bool> submit() async {
    if (state.isSubmitting || state.isSubmitted || state.blockedUnpaid) {
      return false;
    }
    if (state.workshopRating == 0) {
      state = state.copyWith(ratingError: true);
      return false;
    }
    state = state.copyWith(isSubmitting: true, ratingError: false);

    final comment = state.comment.trim();
    final review = Review(
      bookingId: bookingId,
      workshopRating: state.workshopRating,
      workshopComment: comment.isEmpty ? null : comment,
      mechanicRatings: state.showMechanicSection
          ? Map<String, int>.of(state.mechanicRatings)
          : const <String, int>{},
      createdAt: ref.read(clockProvider).now(),
    );
    final result = await ref
        .read(reviewRepositoryProvider)
        .submitReview(review);
    if (!ref.mounted) return false;
    if (result is! Ok<void>) {
      state = state.copyWith(isSubmitting: false);
      return false;
    }
    state = state.copyWith(isSubmitting: false, submitted: review);
    return true;
  }

  Future<void> _load() async {
    final (bookingResult, invoiceResult) = await (
      ref.read(bookingRepositoryProvider).getBooking(bookingId),
      ref.read(invoiceRepositoryProvider).getInvoice(bookingId),
    ).wait;
    if (!ref.mounted) return;
    if (bookingResult is! Ok<Booking> || invoiceResult is! Ok<Invoice>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }
    final booking = bookingResult.value;

    final workshopRepository = ref.read(workshopRepositoryProvider);
    final (workshopResult, mechanicsResult, reviewResult) = await (
      workshopRepository.getWorkshop(booking.workshopId),
      workshopRepository.getMechanics(),
      ref.read(reviewRepositoryProvider).getReview(bookingId),
    ).wait;
    if (!ref.mounted) return;
    if (workshopResult is! Ok<Workshop> || reviewResult is! Ok<Review?>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final existing = reviewResult.value;
    state = state.copyWith(
      isLoading: false,
      hasError: false,
      workshopName: workshopResult.value.name,
      mechanics: _mechanicItems(
        booking,
        mechanicsResult is Ok<List<Mechanic>>
            ? mechanicsResult.value
            : const <Mechanic>[],
      ),
      submitted: existing,
      blockedUnpaid: existing == null && !invoiceResult.value.isPaid,
    );
  }

  List<MechanicRatingItem> _mechanicItems(
    Booking booking,
    List<Mechanic> mechanics,
  ) {
    final byId = {for (final m in mechanics) m.id: m};
    final unitsByMechanic = <String, List<String>>{};
    for (final unit in booking.units) {
      final id = unit.mechanicId;
      if (id == null || !byId.containsKey(id)) continue;
      unitsByMechanic
          .putIfAbsent(id, () => [])
          .add(unit.motorSnapshot.nickname);
    }
    return [
      for (final entry in unitsByMechanic.entries)
        MechanicRatingItem(
          mechanicId: entry.key,
          name: byId[entry.key]!.name,
          initial: byId[entry.key]!.avatarInitial,
          unitsLabel: entry.value.join(' + '),
        ),
    ];
  }
}
