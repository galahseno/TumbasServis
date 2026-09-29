import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';

part 'tiket_state.freezed.dart';

@freezed
abstract class TiketState with _$TiketState {
  const factory TiketState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    Booking? booking,
    Workshop? workshop,
    @Default(<String, ServiceType>{}) Map<String, ServiceType> serviceById,

    @Default(0) int copyCount,
  }) = _TiketState;
}
