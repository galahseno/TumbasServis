import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/tracking/presentation/detail_booking/detail_booking_view_model.dart';
import 'package:tumbas_servis/tracking/presentation/detail_booking/state/detail_booking_state.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/lacak_unit_view_model.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/state/lacak_unit_state.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/riwayat_view_model.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/state/riwayat_state.dart';
import 'package:tumbas_servis/tracking/presentation/ubah_jadwal_batalkan/state/ubah_jadwal_state.dart';
import 'package:tumbas_servis/tracking/presentation/ubah_jadwal_batalkan/ubah_jadwal_view_model.dart';

final riwayatViewModelProvider = NotifierProvider.autoDispose
    .family<RiwayatViewModel, RiwayatState, String?>(RiwayatViewModel.new);

final detailBookingViewModelProvider = NotifierProvider.autoDispose
    .family<DetailBookingViewModel, DetailBookingState, String>(
      DetailBookingViewModel.new,
    );

final ubahJadwalViewModelProvider = NotifierProvider.autoDispose
    .family<UbahJadwalViewModel, UbahJadwalState, UbahJadwalArgs>(
      UbahJadwalViewModel.new,
    );

final lacakUnitViewModelProvider = NotifierProvider.autoDispose
    .family<LacakUnitViewModel, LacakUnitState, LacakUnitArgs>(
      LacakUnitViewModel.new,
    );
