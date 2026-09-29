import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';

part 'invoice_state.freezed.dart';

@freezed
abstract class InvoiceState with _$InvoiceState {
  const factory InvoiceState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    Invoice? invoice,
    Booking? booking,
    @Default('') String workshopName,
    @Default('') String workshopAddress,
    String? voucherCode,
    @Default(false) bool hasReview,
    @Default(false) bool isMarking,
    @Default(false) bool markFailed,
  }) = _InvoiceState;

  const InvoiceState._();

  static const loadingReason = 'Memuat invoice…';

  bool get isPaid => invoice?.isPaid ?? false;

  bool get isReady => !isLoading && !hasError && invoice != null;
}
