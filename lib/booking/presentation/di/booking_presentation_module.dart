import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/presentation/booking_draft/booking_draft_view_model.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_view_model.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/state/pilih_motor_state.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';

final bookingDraftProvider =
    NotifierProvider<BookingDraftViewModel, BookingDraft?>(
      BookingDraftViewModel.new,
    );

final pilihMotorViewModelProvider =
    NotifierProvider<PilihMotorViewModel, PilihMotorState>(
      PilihMotorViewModel.new,
    );
