import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/detail_bengkel_view_model.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/state/detail_bengkel_state.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/pilih_bengkel_view_model.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/state/pilih_bengkel_state.dart';

final pilihBengkelViewModelProvider =
    NotifierProvider<PilihBengkelViewModel, PilihBengkelState>(
      PilihBengkelViewModel.new,
    );

final detailBengkelViewModelProvider =
    NotifierProvider<DetailBengkelViewModel, DetailBengkelState>(
      DetailBengkelViewModel.new,
    );
