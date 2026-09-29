import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/demo_mode_view_model.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/state/demo_mode_state.dart';
import 'package:tumbas_servis/profile/presentation/profil/profil_view_model.dart';
import 'package:tumbas_servis/profile/presentation/profil/state/profil_state.dart';

final profilViewModelProvider =
    NotifierProvider.autoDispose<ProfilViewModel, ProfilState>(
      ProfilViewModel.new,
    );

final demoModeViewModelProvider =
    NotifierProvider.autoDispose<DemoModeViewModel, DemoModeState>(
      DemoModeViewModel.new,
    );
