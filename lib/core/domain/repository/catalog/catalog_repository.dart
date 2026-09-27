import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

abstract class CatalogRepository {
  Future<Result<List<ServiceType>>> getServiceTypes();
  Future<Result<List<Part>>> getParts({String? modelId});
  Future<Result<List<Voucher>>> getVouchers();
  Future<Result<List<Promo>>> getPromos();
}
