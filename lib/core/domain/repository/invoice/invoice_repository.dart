import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

abstract class InvoiceRepository {
  Future<Result<Invoice>> getInvoice(String bookingId);
  Future<Result<void>> markPaid(String bookingId);
}
