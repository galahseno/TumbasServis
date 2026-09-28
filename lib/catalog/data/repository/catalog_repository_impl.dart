// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/catalog/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({
    required MockJsonLoader mockJsonLoader,
    required LatencySimulator latencySimulator,
  }) : _mockJsonLoader = mockJsonLoader,
       _latencySimulator = latencySimulator;

  final MockJsonLoader _mockJsonLoader;
  final LatencySimulator _latencySimulator;

  @override
  Future<Result<List<ServiceType>>> getServiceTypes() async {
    try {
      await _latencySimulator.simulate();
      final json = await _mockJsonLoader.load('services.json') as List<dynamic>;
      return Result.ok(
        json.cast<Map<String, dynamic>>().map(_serviceTypeFromJson).toList(),
      );
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Part>>> getParts({String? modelId}) async {
    try {
      await _latencySimulator.simulate();
      final json = await _mockJsonLoader.load('parts.json') as List<dynamic>;
      final parts = json
          .cast<Map<String, dynamic>>()
          .map(_partFromJson)
          .where(
            (part) =>
                modelId == null || part.compatibleModelIds.contains(modelId),
          )
          .toList();
      return Result.ok(parts);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Voucher>>> getVouchers() async {
    try {
      await _latencySimulator.simulate();
      final json = await _mockJsonLoader.load('vouchers.json') as List<dynamic>;
      return Result.ok(
        json.cast<Map<String, dynamic>>().map(_voucherFromJson).toList(),
      );
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Promo>>> getPromos() async {
    try {
      await _latencySimulator.simulate();
      final json = await _mockJsonLoader.load('promos.json') as List<dynamic>;
      return Result.ok(
        json.cast<Map<String, dynamic>>().map(_promoFromJson).toList(),
      );
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  ServiceType _serviceTypeFromJson(Map<String, dynamic> json) => ServiceType(
    id: json['id'] as String,
    name: json['name'] as String,
    price: json['price'] as int,
    durationMin: json['duration_min'] as int,
    requiresComplaint: json['requires_complaint'] as bool,
  );

  Part _partFromJson(Map<String, dynamic> json) => Part(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    brand: json['brand'] as String,
    grade: json['grade'] as String,
    price: json['price'] as int,
    compatibleModelIds: (json['compatible_model_ids'] as List<dynamic>)
        .cast<String>(),
  );

  Voucher _voucherFromJson(Map<String, dynamic> json) => Voucher(
    id: json['id'] as String,
    code: json['code'] as String,
    label: json['label'] as String,
    discountType: DiscountTypeX.fromString(json['discount_type'] as String?),
    discountValue: json['discount_value'] as int,
    minUnits: json['min_units'] as int?,
    minSubtotal: json['min_subtotal'] as int?,
    validUntil: DateTime.parse(json['valid_until'] as String),
  );

  Promo _promoFromJson(Map<String, dynamic> json) => Promo(
    id: json['id'] as String,
    title: json['title'] as String,
    imageAssetPath: json['image_asset_path'] as String,
    deepLink: json['deep_link'] as String?,
  );
}
