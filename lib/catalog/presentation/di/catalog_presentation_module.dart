import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_view_model.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';

final katalogViewModelProvider =
    NotifierProvider.autoDispose<KatalogViewModel, KatalogState>(
      KatalogViewModel.new,
    );
