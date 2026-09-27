import 'dart:convert';

import 'package:flutter/services.dart';

class MockJsonLoader {
  MockJsonLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final Map<String, dynamic> _cache = {};

  Future<dynamic> load(String assetFileName) async {
    final cached = _cache[assetFileName];
    if (cached != null) return cached;
    final raw = await _bundle.loadString('assets/mock/$assetFileName');
    final decoded = json.decode(raw);
    _cache[assetFileName] = decoded;
    return decoded;
  }
}
