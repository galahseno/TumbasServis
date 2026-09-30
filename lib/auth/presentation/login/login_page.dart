import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/presentation/components/auth_layout.dart';
import 'package:tumbas_servis/auth/presentation/di/auth_presentation_module.dart';
import 'package:tumbas_servis/auth/presentation/login/components/phone_field.dart';
import 'package:tumbas_servis/auth/presentation/login/components/terms_note.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = TsThemeExtension.of(context);

    ref.listen(loginViewModelProvider, (previous, next) {
      if (next.snackbarMessage != null) {
        TsSnackbar.error(
          context,
          next.snackbarMessage!,
          actionLabel: 'Coba lagi',
          onAction: viewModel.submit,
        );
        viewModel.clearSnackbar();
      }
    });

    return AuthLayout(
      showLogo: true,
      footer: const TermsNote(),
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masuk ke TumbasServis',
            style: textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Masukkan nomor HP-mu untuk mulai booking servis.',
            style: textTheme.bodyLarge?.copyWith(color: ext.textMuted),
          ),
          const SizedBox(height: 32),
          PhoneField(
            digits: state.phoneDigits,
            errorText: state.errorText,
            enabled: !state.isLoading,
            onChanged: viewModel.updatePhone,
            onBlur: viewModel.validateOnBlur,
          ),
          const SizedBox(height: 24),
          TsButton(
            label: 'Kirim kode OTP',
            isLoading: state.isLoading,
            onPressed: viewModel.submit,
          ),
        ],
      ),
    );
  }
}
