import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class TermsNote extends StatelessWidget {
  const TermsNote({super.key});

  void _showComingSoon(BuildContext context) =>
      TsSnackbar.info(context, 'Segera hadir');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ext = TsThemeExtension.of(context);
    final bodyStyle = textTheme.bodySmall?.copyWith(color: ext.textMuted);
    final linkStyle = bodyStyle?.copyWith(
      color: ext.textAccent,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dengan melanjutkan, kamu setuju dengan', style: bodyStyle),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Syarat & Ketentuan',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _showComingSoon(context),
              ),
              TextSpan(text: ' dan ', style: bodyStyle),
              TextSpan(
                text: 'Kebijakan Privasi',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _showComingSoon(context),
              ),
              TextSpan(text: '.', style: bodyStyle),
            ],
          ),
        ),
      ],
    );
  }
}
