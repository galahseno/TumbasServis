import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/notification/presentation/notifikasi/notifikasi_view_model.dart';
import 'package:tumbas_servis/notification/presentation/notifikasi/state/notifikasi_state.dart';

final notifikasiViewModelProvider =
    NotifierProvider.autoDispose<NotifikasiViewModel, NotifikasiState>(
      NotifikasiViewModel.new,
    );
