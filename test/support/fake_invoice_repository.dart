import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/invoice/invoice_repository.dart';

class FakeInvoiceRepository implements InvoiceRepository {
  bool paid = false;
  bool fail = false;
  final List<String> getInvoiceCalls = [];

  @override
  Future<Result<Invoice>> getInvoice(String bookingId) async {
    getInvoiceCalls.add(bookingId);
    if (fail) return Result.error(Exception('invoice unavailable'));
    return Result.ok(
      Invoice(
        bookingId: bookingId,
        lines: const [],
        subtotal: 0,
        discount: 0,
        total: 0,
        isPaid: paid,
        issuedAt: DateTime(2026, 9, 29, 10, 30),
      ),
    );
  }

  @override
  Future<Result<void>> markPaid(String bookingId) async {
    paid = true;
    return const Result.ok(null);
  }
}
