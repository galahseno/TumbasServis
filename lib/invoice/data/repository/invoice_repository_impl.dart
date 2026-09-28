// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice_line.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/booking/booking_repository.dart';
import 'package:tumbas_servis/core/domain/repository/catalog/catalog_repository.dart';
import 'package:tumbas_servis/core/domain/repository/invoice/invoice_repository.dart';
import 'package:tumbas_servis/core/domain/service/clock.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl({
    required LocalStore localStore,
    required LatencySimulator latencySimulator,
    required Clock clock,
    required BookingRepository bookingRepository,
    required CatalogRepository catalogRepository,
  }) : _localStore = localStore,
       _latencySimulator = latencySimulator,
       _clock = clock,
       _bookingRepository = bookingRepository,
       _catalogRepository = catalogRepository;

  final LocalStore _localStore;
  final LatencySimulator _latencySimulator;
  final Clock _clock;
  final BookingRepository _bookingRepository;
  final CatalogRepository _catalogRepository;

  static const _invoicesBox = 'invoices';

  @override
  Future<Result<Invoice>> getInvoice(String bookingId) async {
    try {
      await _latencySimulator.simulate();
      return await _getOrCreateInvoice(bookingId);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> markPaid(String bookingId) async {
    try {
      await _latencySimulator.simulate();
      final result = await _getOrCreateInvoice(bookingId);
      if (result is Error<Invoice>) return Result.error(result.error);
      final invoice = (result as Ok<Invoice>).value;
      if (invoice.isPaid) return const Result.ok(null);
      final paid = invoice.copyWith(isPaid: true, paidAt: _clock.now());
      await _localStore.put(_invoicesBox, bookingId, _invoiceToJson(paid));
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<Invoice>> _getOrCreateInvoice(String bookingId) async {
    final existing = await _localStore.get(_invoicesBox, bookingId);
    if (existing != null) return Result.ok(_invoiceFromJson(existing));

    final bookingResult = await _bookingRepository.getBooking(bookingId);
    if (bookingResult is Error<Booking>) {
      return Result.error(bookingResult.error);
    }
    final booking = (bookingResult as Ok<Booking>).value;
    if (booking.status != BookingStatus.selesai) {
      return Result.error(
        Exception('Booking belum selesai, invoice belum tersedia.'),
      );
    }

    final lines = <InvoiceLine>[];
    for (final unit in booking.units) {
      if (unit.status != UnitStatus.selesai) continue;
      lines.addAll(await _linesForUnit(unit));
    }

    final subtotal = lines.fold<int>(0, (sum, l) => sum + l.qty * l.price);
    final discount = booking.discount;
    final invoice = Invoice(
      bookingId: bookingId,
      lines: lines,
      subtotal: subtotal,
      discount: discount,
      total: subtotal - discount,
      isPaid: false,
      issuedAt: booking.completedAt ?? _clock.now(),
    );
    await _localStore.put(_invoicesBox, bookingId, _invoiceToJson(invoice));
    return Result.ok(invoice);
  }

  Future<List<InvoiceLine>> _linesForUnit(BookingUnit unit) async {
    final serviceTypesResult = await _catalogRepository.getServiceTypes();
    final partsResult = await _catalogRepository.getParts();
    final serviceTypes = serviceTypesResult is Ok<List<ServiceType>>
        ? serviceTypesResult.value
        : const <ServiceType>[];
    final parts = partsResult is Ok<List<Part>>
        ? partsResult.value
        : const <Part>[];

    final counts = <String, int>{};
    for (final id in [...unit.serviceIds, ...unit.partIds]) {
      counts[id] = (counts[id] ?? 0) + 1;
    }

    final lines = <InvoiceLine>[];
    for (final entry in counts.entries) {
      final service = _findService(serviceTypes, entry.key);
      if (service != null) {
        lines.add(
          InvoiceLine(
            unitCode: unit.unitCode,
            label: service.name,
            qty: entry.value,
            price: service.price,
          ),
        );
        continue;
      }
      final part = _findPart(parts, entry.key);
      if (part != null) {
        lines.add(
          InvoiceLine(
            unitCode: unit.unitCode,
            label: part.name,
            qty: entry.value,
            price: part.price,
          ),
        );
      }
    }
    return lines;
  }

  ServiceType? _findService(List<ServiceType> items, String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  Part? _findPart(List<Part> items, String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  Invoice _invoiceFromJson(Map<String, dynamic> json) => Invoice(
    bookingId: json['booking_id'] as String,
    lines: (json['lines'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_invoiceLineFromJson)
        .toList(),
    subtotal: json['subtotal'] as int,
    discount: json['discount'] as int,
    total: json['total'] as int,
    isPaid: json['is_paid'] as bool,
    paidAt: json['paid_at'] == null
        ? null
        : DateTime.parse(json['paid_at'] as String),
    issuedAt: DateTime.parse(json['issued_at'] as String),
  );

  Map<String, dynamic> _invoiceToJson(Invoice invoice) => {
    'booking_id': invoice.bookingId,
    'lines': invoice.lines.map(_invoiceLineToJson).toList(),
    'subtotal': invoice.subtotal,
    'discount': invoice.discount,
    'total': invoice.total,
    'is_paid': invoice.isPaid,
    'paid_at': invoice.paidAt?.toIso8601String(),
    'issued_at': invoice.issuedAt.toIso8601String(),
  };

  InvoiceLine _invoiceLineFromJson(Map<String, dynamic> json) => InvoiceLine(
    unitCode: json['unit_code'] as String,
    label: json['label'] as String,
    qty: json['qty'] as int,
    price: json['price'] as int,
  );

  Map<String, dynamic> _invoiceLineToJson(InvoiceLine line) => {
    'unit_code': line.unitCode,
    'label': line.label,
    'qty': line.qty,
    'price': line.price,
  };
}
