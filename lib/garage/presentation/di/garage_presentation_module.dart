import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/garage/presentation/garasi/garasi_view_model.dart';
import 'package:tumbas_servis/garage/presentation/garasi/state/garasi_state.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/motor_detail_view_model.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/state/motor_detail_state.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/motor_form_view_model.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/state/motor_form_state.dart';

final garasiViewModelProvider = NotifierProvider<GarasiViewModel, GarasiState>(
  GarasiViewModel.new,
);

final motorFormViewModelProvider =
    NotifierProvider.autoDispose<MotorFormViewModel, MotorFormState>(
      MotorFormViewModel.new,
    );

final motorDetailViewModelProvider =
    NotifierProvider.autoDispose<MotorDetailViewModel, MotorDetailState>(
      MotorDetailViewModel.new,
    );
