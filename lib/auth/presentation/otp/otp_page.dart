import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/auth/presentation/components/auth_layout.dart';
import 'package:tumbas_servis/auth/presentation/di/auth_presentation_module.dart';
import 'package:tumbas_servis/auth/presentation/otp/components/auth_link.dart';
import 'package:tumbas_servis/auth/presentation/otp/components/otp_input.dart';
import 'package:tumbas_servis/auth/presentation/otp/otp_view_model.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/phone_formatter.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is String) {
        ref.read(otpViewModelProvider.notifier).setPhone(extra);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpViewModelProvider);
    final viewModel = ref.read(otpViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = TsThemeExtension.of(context);
    final canVerify = state.code.length == otpDigitCount && !state.isLoading;

    return AuthLayout(
      showBack: true,
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan kode OTP',
            style: textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Kode 6 digit dikirim lewat SMS ke',
            style: textTheme.bodyLarge?.copyWith(color: ext.textMuted),
          ),
          const SizedBox(height: 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(
                '+62 ${maskPhoneDisplay(state.phoneDigits)}',
                style: textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AuthLink(
                label: 'Ganti nomor',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          OtpInput(
            value: state.code,
            isError: state.isError,
            enabled: !state.isLoading,
            onChanged: viewModel.updateCode,
          ),
          if (state.isError) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.error_outline_rounded, size: 16, color: ext.danger),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    wrongOtpError,
                    style: textTheme.bodySmall?.copyWith(color: ext.dangerText),
                  ),
                ),
              ],
            ),
          ],
          if (kDebugMode) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ext.infoSoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: ext.infoText,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Kode demo: 123456',
                      style: textTheme.labelLarge?.copyWith(
                        color: ext.infoText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          AuthLink(
            label: state.secondsRemaining > 0
                ? 'Kirim ulang kode dalam '
                      '0:${state.secondsRemaining.toString().padLeft(2, '0')}'
                : 'Kirim ulang kode',
            leadingIcon: state.secondsRemaining > 0
                ? Icons.schedule_rounded
                : null,
            onPressed: state.secondsRemaining > 0 ? null : viewModel.resend,
          ),
          const SizedBox(height: 16),
          TsButton(
            label: 'Verifikasi',
            isLoading: state.isLoading,
            onPressed: canVerify ? viewModel.verify : null,
          ),
          if (state.code.length < otpDigitCount) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: ext.textMuted,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Masukkan 6 digit kode',
                    style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
