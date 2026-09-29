import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/state/invoice_state.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

class InvoiceViewModel extends Notifier<InvoiceState> {
  InvoiceViewModel(this.bookingId);

  final String bookingId;

  @override
  InvoiceState build() {
    _load();
    return const InvoiceState();
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> refresh() => _load();

  Future<bool> markPaid() async {
    if (state.isMarking || state.isPaid) return false;
    state = state.copyWith(isMarking: true, markFailed: false);
    final result = await ref
        .read(invoiceRepositoryProvider)
        .markPaid(bookingId);
    if (!ref.mounted) return false;
    if (result is! Ok<void>) {
      state = state.copyWith(isMarking: false, markFailed: true);
      return false;
    }
    final invoiceResult = await ref
        .read(invoiceRepositoryProvider)
        .getInvoice(bookingId);
    if (!ref.mounted) return false;
    if (invoiceResult is! Ok<Invoice>) {
      state = state.copyWith(isMarking: false, markFailed: true);
      return false;
    }
    state = state.copyWith(
      isMarking: false,
      markFailed: false,
      invoice: invoiceResult.value,
    );
    return true;
  }

  Future<void> _load() async {
    final (invoiceResult, bookingResult) = await (
      ref.read(invoiceRepositoryProvider).getInvoice(bookingId),
      ref.read(bookingRepositoryProvider).getBooking(bookingId),
    ).wait;
    if (!ref.mounted) return;
    if (invoiceResult is! Ok<Invoice> || bookingResult is! Ok<Booking>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }
    final booking = bookingResult.value;

    final (workshopResult, reviewResult, vouchersResult) = await (
      ref.read(workshopRepositoryProvider).getWorkshop(booking.workshopId),
      ref.read(reviewRepositoryProvider).getReview(bookingId),
      booking.voucherId == null
          ? Future<Result<List<Voucher>>?>.value()
          : ref.read(catalogRepositoryProvider).getVouchers(),
    ).wait;
    if (!ref.mounted) return;
    if (workshopResult is! Ok<Workshop>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      invoice: invoiceResult.value,
      booking: booking,
      workshopName: workshopResult.value.name,
      workshopAddress: workshopResult.value.address,
      voucherCode: _voucherCode(vouchersResult, booking.voucherId),
      hasReview: reviewResult is Ok<Review?> && reviewResult.value != null,
    );
  }

  String? _voucherCode(Result<List<Voucher>>? result, String? voucherId) {
    if (result is! Ok<List<Voucher>> || voucherId == null) return null;
    for (final voucher in result.value) {
      if (voucher.id == voucherId) return voucher.code;
    }
    return null;
  }
}
