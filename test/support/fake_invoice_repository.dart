import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice_line.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/invoice/invoice_repository.dart';

class FakeInvoiceRepository implements InvoiceRepository {
  bool paid = false;
  bool fail = false;
  bool failMarkPaid = false;
  List<InvoiceLine> lines = const [];
  int discount = 0;
  DateTime issuedAt = DateTime(2026, 9, 29, 10, 30);
  DateTime paidAt = DateTime(2026, 9, 29, 11, 24);
  Duration delay = Duration.zero;
  final List<String> getInvoiceCalls = [];
  final List<String> markPaidCalls = [];

  @override
  Future<Result<Invoice>> getInvoice(String bookingId) async {
    getInvoiceCalls.add(bookingId);
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (fail) return Result.error(Exception('invoice unavailable'));
    final subtotal = lines.fold<int>(0, (sum, l) => sum + l.qty * l.price);
    return Result.ok(
      Invoice(
        bookingId: bookingId,
        lines: lines,
        subtotal: subtotal,
        discount: discount,
        total: subtotal - discount,
        isPaid: paid,
        paidAt: paid ? paidAt : null,
        issuedAt: issuedAt,
      ),
    );
  }

  @override
  Future<Result<void>> markPaid(String bookingId) async {
    markPaidCalls.add(bookingId);
    if (failMarkPaid) return Result.error(Exception('mark paid failed'));
    paid = true;
    return const Result.ok(null);
  }
}
