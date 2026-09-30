import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_text_field.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/core/presentation/utils/plate_formatter.dart';
import 'package:tumbas_servis/garage/presentation/di/garage_presentation_module.dart';
import 'package:tumbas_servis/app/navigation/garage_result.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/components/discard_changes_dialog.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/components/motor_model_picker.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/components/motor_photo_field.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/components/motor_preview_pane.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/state/motor_form_state.dart';
import 'package:tumbas_servis/garage/presentation/utils/motor_display.dart';

class MotorFormPage extends ConsumerStatefulWidget {
  const MotorFormPage({super.key, this.existingMotor});

  final Motor? existingMotor;

  @override
  ConsumerState<MotorFormPage> createState() => _MotorFormPageState();
}

class _MotorFormPageState extends ConsumerState<MotorFormPage> {
  late final TextEditingController _nicknameController;
  late final TextEditingController _modelController;
  late final TextEditingController _plateController;
  late final TextEditingController _yearController;
  final _nicknameFocus = FocusNode();
  final _modelFocus = FocusNode();
  final _plateFocus = FocusNode();
  final _yearFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final motor = widget.existingMotor;
    _nicknameController = TextEditingController(text: motor?.nickname ?? '');
    _modelController = TextEditingController();
    _plateController = TextEditingController(text: motor?.plateNumber ?? '');
    _yearController = TextEditingController(
      text: motor?.year?.toString() ?? '',
    );

    _plateFocus.addListener(() {
      if (!_plateFocus.hasFocus) {
        ref.read(motorFormViewModelProvider.notifier).validatePlateOnBlur();
      }
    });
    _yearFocus.addListener(() {
      if (!_yearFocus.hasFocus) {
        ref.read(motorFormViewModelProvider.notifier).validateYearOnBlur();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(motorFormViewModelProvider.notifier)
          .initialize(existingMotor: widget.existingMotor);
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _yearController.dispose();
    _nicknameFocus.dispose();
    _modelFocus.dispose();
    _plateFocus.dispose();
    _yearFocus.dispose();
    super.dispose();
  }

  void _syncController(TextEditingController controller, String text) {
    if (controller.text == text) return;
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  Future<void> _handleBack() async {
    final state = ref.read(motorFormViewModelProvider);
    if (state.isSaving) return;
    if (!state.isDirty) {
      Navigator.of(context).pop();
      return;
    }
    final discard = await showDiscardChangesDialog(context);
    if (discard && mounted) Navigator.of(context).pop();
  }

  Future<void> _openModelPicker() async {
    final state = ref.read(motorFormViewModelProvider);
    if (state.isSaving || state.models.isEmpty) return;
    FocusScope.of(context).unfocus();
    final picked = await showMotorModelPicker(
      context,
      models: state.models,
      selectedModelId: state.selectedModel?.id,
    );
    if (picked == null || !mounted) return;
    ref.read(motorFormViewModelProvider.notifier).selectModel(picked);
  }

  Future<void> _submit() async {
    final viewModel = ref.read(motorFormViewModelProvider.notifier);
    final isEdit = ref.read(motorFormViewModelProvider).isEditMode;
    FocusScope.of(context).unfocus();
    final saved = await viewModel.submit();
    if (!mounted) return;

    if (saved) {
      ref.invalidate(garasiViewModelProvider);
      context.pop(
        isEdit ? GarageMotorResult.updated : GarageMotorResult.created,
      );
      return;
    }
    switch (ref.read(motorFormViewModelProvider).firstInvalidField) {
      case MotorFormField.nickname:
        _nicknameFocus.requestFocus();
      case MotorFormField.model:
        _modelFocus.requestFocus();
      case MotorFormField.plate:
        _plateFocus.requestFocus();
      case MotorFormField.year:
        _yearFocus.requestFocus();
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(motorFormViewModelProvider.select((s) => s.nickname), (_, next) {
        _syncController(_nicknameController, next);
      })
      ..listen(motorFormViewModelProvider.select((s) => s.selectedModel), (
        _,
        next,
      ) {
        _syncController(
          _modelController,
          next == null ? '' : modelDisplayName(next),
        );
      })
      ..listen(
        motorFormViewModelProvider.select((s) => s.pendingSnackbarMessage),
        (_, next) {
          if (next == null) return;
          TsSnackbar.error(context, next);
          ref.read(motorFormViewModelProvider.notifier).clearPendingSnackbar();
        },
      );

    final state = ref.watch(motorFormViewModelProvider);
    final viewModel = ref.read(motorFormViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final enabled = !state.isSaving;

    final isWide = context.windowSizeClass.isAtLeast(WindowSizeClass.expanded);
    final formColumn = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: state.isLoading && state.models.isEmpty
                    ? const _FormSkeleton()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MotorPhotoField(
                            photoPath: state.photoPath,
                            enabled: enabled,
                            onPick: viewModel.pickPhoto,
                            onRemove: viewModel.removePhoto,
                          ),
                          const SizedBox(height: 24),
                          TsTextField(
                            label: 'Nama panggilan',
                            placeholder: 'Contoh: Vario 125',
                            helperText: 'Tampil di Garasi dan saat booking.',
                            controller: _nicknameController,
                            focusNode: _nicknameFocus,
                            enabled: enabled,
                            maxLength: Motor.nicknameMaxLength,
                            errorText: state.nicknameError,
                            onChanged: viewModel.updateNickname,
                          ),
                          const SizedBox(height: 16),
                          TsTextField(
                            label: 'Model motor',
                            placeholder: 'Pilih model',
                            controller: _modelController,
                            focusNode: _modelFocus,
                            enabled: enabled,
                            readOnly: true,
                            suffixIcon: Icons.keyboard_arrow_down_rounded,
                            errorText: state.modelError,
                            onTap: _openModelPicker,
                          ),
                          const SizedBox(height: 16),
                          TsTextField(
                            label: 'Plat nomor',
                            placeholder: 'AB 1234 XY',
                            helperText: 'Contoh: AB 1234 XY',
                            controller: _plateController,
                            focusNode: _plateFocus,
                            enabled: enabled,
                            errorText: state.plateError,
                            keyboardType: TextInputType.text,
                            inputFormatters: const [PlateNumberFormatter()],
                            onChanged: viewModel.updatePlate,
                          ),
                          const SizedBox(height: 16),
                          TsTextField(
                            label: 'Tahun (opsional)',
                            placeholder: '2015',
                            helperText: 'Tahun produksi, 1990–2026',
                            controller: _yearController,
                            focusNode: _yearFocus,
                            enabled: enabled,
                            errorText: state.yearError,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onChanged: viewModel.updateYear,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(top: BorderSide(color: ext.borderDefault)),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.saveError) ...[
                    _SaveErrorBanner(onRetry: _submit),
                    const SizedBox(height: 12),
                  ],
                  TsButton(
                    label: state.isEditMode ? 'Simpan perubahan' : 'Simpan',
                    isLoading: state.isSaving,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return PopScope(
      canPop: !state.isDirty && !state.isSaving,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: scheme.surface,
        appBar: TsAppBar.back(
          title: state.isEditMode ? 'Ubah motor' : 'Tambah motor',
          onBack: _handleBack,
        ),
        body: SafeArea(
          top: false,
          child: isWide
              ? Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 600 + 24 + 360 + 48,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: formColumn,
                            ),
                          ),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 360,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: MotorPreviewPane(
                                nickname: state.nickname,
                                plateNumber: state.plateNumber,
                                model: state.selectedModel,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : formColumn,
        ),
      ),
    );
  }
}

class _FormSkeleton extends StatelessWidget {
  const _FormSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonBlock(height: 96),
        SizedBox(height: 24),
        SkeletonBlock(height: 72),
        SizedBox(height: 16),
        SkeletonBlock(height: 72),
        SizedBox(height: 16),
        SkeletonBlock(height: 72),
      ],
    );
  }
}

class _SaveErrorBanner extends StatelessWidget {
  const _SaveErrorBanner({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ext.dangerSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: ext.dangerText, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Gagal menyimpan motor. Coba lagi.',
                style: textTheme.bodyMedium?.copyWith(color: ext.dangerText),
              ),
            ),
            const SizedBox(width: 8),
            TsButton(
              label: 'Coba lagi',
              type: TsButtonType.dangerOutline,
              compact: true,
              fullWidth: false,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
