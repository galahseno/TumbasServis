import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/catalog/catalog_repository.dart';

class FakeCatalogRepository implements CatalogRepository {
  Result<List<Promo>> promosResult = const Result.ok([]);
  Result<List<ServiceType>> serviceTypesResult = const Result.ok([]);
  Result<List<Part>> partsResult = const Result.ok([]);

  @override
  Future<Result<List<ServiceType>>> getServiceTypes() async =>
      serviceTypesResult;

  @override
  Future<Result<List<Part>>> getParts({String? modelId}) async => partsResult;

  @override
  Future<Result<List<Voucher>>> getVouchers() async => const Result.ok([]);

  @override
  Future<Result<List<Promo>>> getPromos() async => promosResult;
}
