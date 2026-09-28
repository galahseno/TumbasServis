import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/home/presentation/home/home_view_model.dart';
import 'package:tumbas_servis/home/presentation/home/state/home_state.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';

final Provider<DemoContentSeeder> demoContentSeederProvider =
    Provider<DemoContentSeeder>((ref) {
      return DemoContentSeeder(
        bookingRepository: ref.watch(bookingRepositoryProvider),
        trackingRepository: ref.watch(trackingRepositoryProvider),
      );
    });

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);
