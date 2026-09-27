import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice_line.dart';

part 'invoice.freezed.dart';

@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    required String bookingId,
    required List<InvoiceLine> lines,
    required int subtotal,
    required int discount,
    required int total,
    required bool isPaid,
    DateTime? paidAt,
    required DateTime issuedAt,
  }) = _Invoice;
}
