import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/review/presentation/ulasan/state/ulasan_state.dart';
import 'package:tumbas_servis/review/presentation/ulasan/ulasan_view_model.dart';

final ulasanViewModelProvider = NotifierProvider.autoDispose
    .family<UlasanViewModel, UlasanState, String>(UlasanViewModel.new);
