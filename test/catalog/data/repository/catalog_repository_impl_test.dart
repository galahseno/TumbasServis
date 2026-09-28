import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/catalog/data/repository/catalog_repository_impl.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CatalogRepositoryImpl repository;

  setUp(() {
    repository = CatalogRepositoryImpl(
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
    );
  });

  test('getServiceTypes returns all seeded service types', () async {
    final result = await repository.getServiceTypes();
    expect(result, isA<Ok<List<ServiceType>>>());
    expect((result as Ok<List<ServiceType>>).value, hasLength(3));
  });

  test('getParts with no filter returns the full catalog', () async {
    final result = await repository.getParts();
    expect(result, isA<Ok<List<Part>>>());
    expect((result as Ok<List<Part>>).value, hasLength(14));
  });

  test('getParts filters by compatible model id', () async {
    final result = await repository.getParts(modelId: 'model_cb150r');
    expect(result, isA<Ok<List<Part>>>());
    final parts = (result as Ok<List<Part>>).value;
    expect(parts, isNotEmpty);
    expect(
      parts.every((p) => p.compatibleModelIds.contains('model_cb150r')),
      isTrue,
    );
  });

  test('getVouchers returns all seeded vouchers', () async {
    final result = await repository.getVouchers();
    expect(result, isA<Ok<List<Voucher>>>());
    expect((result as Ok<List<Voucher>>).value, hasLength(4));
  });

  test('getPromos returns all seeded promos', () async {
    final result = await repository.getPromos();
    expect(result, isA<Ok<List<Promo>>>());
    expect((result as Ok<List<Promo>>).value, hasLength(3));
  });
}
