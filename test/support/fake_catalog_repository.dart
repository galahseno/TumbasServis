import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/catalog/catalog_repository.dart';

class FakeCatalogRepository implements CatalogRepository {
  Result<List<Promo>> promosResult = const Result.ok([]);

  @override
  Future<Result<List<ServiceType>>> getServiceTypes() async =>
      const Result.ok([]);

  @override
  Future<Result<List<Part>>> getParts({String? modelId}) async =>
      const Result.ok([]);

  @override
  Future<Result<List<Voucher>>> getVouchers() async => const Result.ok([]);

  @override
  Future<Result<List<Promo>>> getPromos() async => promosResult;
}
