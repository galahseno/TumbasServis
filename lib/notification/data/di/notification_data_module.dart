import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/notification/notification_repository.dart';
import 'package:tumbas_servis/notification/data/repository/notification_repository_impl.dart';

final Provider<NotificationRepository> notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
      return NotificationRepositoryImpl(
        localStore: ref.watch(localStoreProvider),
        mockJsonLoader: ref.watch(mockJsonLoaderProvider),
        latencySimulator: ref.watch(latencySimulatorProvider),
      );
    });
