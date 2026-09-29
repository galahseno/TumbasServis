import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/invoice/invoice_repository.dart';
import 'package:tumbas_servis/invoice/data/repository/invoice_repository_impl.dart';

final Provider<InvoiceRepository> invoiceRepositoryProvider =
    Provider<InvoiceRepository>((ref) {
      return InvoiceRepositoryImpl(
        localStore: ref.watch(localStoreProvider),
        latencySimulator: ref.watch(latencySimulatorProvider),
        clock: ref.watch(clockProvider),
        bookingRepository: ref.watch(bookingRepositoryProvider),
        catalogRepository: ref.watch(catalogRepositoryProvider),
        demoModeController: ref.watch(demoModeControllerProvider),
      );
    });
