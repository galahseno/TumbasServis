import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_icon_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/components/vehicle_select_card.dart';
import 'package:tumbas_servis/garage/presentation/di/garage_presentation_module.dart';
import 'package:tumbas_servis/garage/presentation/utils/motor_display.dart';
import 'package:tumbas_servis/app/navigation/garage_result.dart';

class GarasiPage extends ConsumerWidget {
  const GarasiPage({super.key});

  Future<void> _handleAdd(BuildContext context) async {
    final result = await context.push<GarageMotorResult>(Routes.garageAdd);
    if (!context.mounted) return;
    if (result == GarageMotorResult.created) {
      TsSnackbar.success(
        context,
        'Motor ditambahkan',
        aboveNavBar: context.windowSizeClass.isCompact,
      );
    }
  }

  Future<void> _handleOpen(BuildContext context, Motor motor) async {
    final result = await context.push<GarageMotorResult>(
      Routes.garageDetail(motor.id),
    );
    if (!context.mounted) return;
    if (result == GarageMotorResult.deleted) {
      TsSnackbar.success(
        context,
        'Motor dihapus',
        aboveNavBar: context.windowSizeClass.isCompact,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(garasiViewModelProvider);
    final viewModel = ref.read(garasiViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar(
        title: 'Garasi saya',
        actions: [
          if (state.motors.isNotEmpty && !state.hasError)
            TsIconButton(
              icon: Icons.add_rounded,
              style: TsIconButtonStyle.tonal,
              semanticLabel: 'Tambah motor',
              onPressed: () => _handleAdd(context),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat garasi. Coba lagi.',
                onRetry: viewModel.refresh,
                layout: ErrorStateLayout.fullPage,
              )
            : state.isConfirmedEmpty
            ? EmptyState(
                icon: Icons.two_wheeler_rounded,
                title: 'Garasimu masih kosong',
                body: 'Tambahkan motor pertamamu untuk mulai booking servis.',
                ctaLabel: 'Tambah motor pertamamu',
                onCta: () => _handleAdd(context),
              )
            : _MotorGrid(
                isLoading: state.isLoading,
                motors: state.motors,
                inService: state.motorInServiceStatus,
                modelsById: state.modelsById,
                onOpen: (motor) => _handleOpen(context, motor),
                onRefresh: viewModel.refresh,
              ),
      ),
    );
  }
}

class _MotorGrid extends StatelessWidget {
  const _MotorGrid({
    required this.isLoading,
    required this.motors,
    required this.inService,
    required this.modelsById,
    required this.onOpen,
    required this.onRefresh,
  });

  final bool isLoading;
  final List<Motor> motors;
  final Map<String, UnitStatus> inService;
  final Map<String, MotorModel> modelsById;
  final void Function(Motor motor) onOpen;
  final Future<void> Function() onRefresh;

  static String? _caption(MotorModel? model) => model == null
      ? null
      : '${modelDisplayName(model)} · ${motorCategoryLabel(model.category)}';

  int _columnsFor(WindowSizeClass sizeClass) => switch (sizeClass) {
    WindowSizeClass.compact => 1,
    WindowSizeClass.medium => 2,
    WindowSizeClass.expanded || WindowSizeClass.large => 3,
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeClass = context.windowSizeClass;
        final columns = _columnsFor(sizeClass);
        const spacing = 12.0;
        final gutter = sizeClass.isCompact ? 20.0 : 24.0;
        final contentWidth = constraints.maxWidth > 1040
            ? 1040.0
            : constraints.maxWidth;
        final innerWidth = contentWidth - gutter * 2;
        final cardWidth = (innerWidth - (columns - 1) * spacing) / columns;

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(gutter, 12, gutter, 24),
            child: Center(
              child: SizedBox(
                width: innerWidth,
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    if (isLoading)
                      for (var i = 0; i < 3; i++)
                        SizedBox(
                          width: cardWidth,
                          child: const SkeletonBlock(height: 80),
                        )
                    else
                      for (final motor in motors)
                        SizedBox(
                          width: cardWidth,
                          child: VehicleSelectCard(
                            layout: VehicleSelectCardLayout.wide,
                            nickname: motor.nickname,
                            plateNumber: motor.plateNumber,
                            caption: _caption(modelsById[motor.modelId]),
                            inServiceStatus: inService[motor.id],
                            onTap: () => onOpen(motor),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
