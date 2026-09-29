import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/service/unit_config/salin_dari_compatibility_filter.dart';

const _oliMpx1 = Part(
  id: 'part-oli-mpx1',
  name: 'AHM Oli MPX1',
  category: 'oli',
  brand: 'AHM',
  grade: 'MPX1',
  price: 58000,
  compatibleModelIds: ['model-beat', 'model-vario'],
);

const _kampasRemSport = Part(
  id: 'part-kampas-rem-sport',
  name: 'Kampas Rem Sport',
  category: 'rem',
  brand: 'Generic',
  grade: 'sport',
  price: 45000,
  compatibleModelIds: ['model-ninja250'],
);

const _catalogParts = [_oliMpx1, _kampasRemSport];

void main() {
  const filter = SalinDariCompatibilityFilter();

  test('copies compatible parts to a compatible target model', () {
    const source = UnitConfig(
      serviceIds: ['svc-servis-berkala'],
      partIds: ['part-oli-mpx1'],
    );

    final result = filter.copyTo(
      source: source,
      targetModelId: 'model-vario',
      catalogParts: _catalogParts,
    );

    expect(result.partIds, ['part-oli-mpx1']);
    expect(result.droppedIncompatiblePartCount, 0);
  });

  test('drops and reports an incompatible part', () {
    const source = UnitConfig(
      serviceIds: ['svc-servis-berkala'],
      partIds: ['part-oli-mpx1', 'part-kampas-rem-sport'],
    );

    final result = filter.copyTo(
      source: source,
      targetModelId: 'model-vario',
      catalogParts: _catalogParts,
    );

    expect(result.partIds, ['part-oli-mpx1']);
    expect(result.droppedIncompatiblePartCount, 1);
  });

  test('never copies the complaint note', () {
    const source = UnitConfig(
      serviceIds: ['svc-servis-berkala'],
      partIds: ['part-oli-mpx1'],
      complaintNote: 'Bunyi kasar di roda depan',
    );

    final result = filter.copyTo(
      source: source,
      targetModelId: 'model-vario',
      catalogParts: _catalogParts,
    );

    expect(result.serviceIds, ['svc-servis-berkala']);
    expect(result.partIds, ['part-oli-mpx1']);
  });

  test('always carries over every serviceId regardless of target model', () {
    const source = UnitConfig(
      serviceIds: ['svc-servis-berkala', 'svc-ganti-oli'],
      partIds: [],
    );

    final result = filter.copyTo(
      source: source,
      targetModelId: 'model-unrelated',
      catalogParts: _catalogParts,
    );

    expect(result.serviceIds, ['svc-servis-berkala', 'svc-ganti-oli']);
  });
}
