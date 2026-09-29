import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/review/review_repository.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/review/data/repository/review_repository_impl.dart';

final Provider<ReviewRepository> reviewRepositoryProvider =
    Provider<ReviewRepository>((ref) {
      return ReviewRepositoryImpl(
        localStore: ref.watch(localStoreProvider),
        latencySimulator: ref.watch(latencySimulatorProvider),
        invoiceRepository: ref.watch(invoiceRepositoryProvider),
        demoModeController: ref.watch(demoModeControllerProvider),
      );
    });
