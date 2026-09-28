import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

const bookingStepLabels = ['Motor', 'Servis', 'Bengkel & jadwal', 'Ringkasan'];

class BookingStepper extends StatelessWidget {
  const BookingStepper({required this.currentStep, super.key});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 600;

    final stepLabel = bookingStepLabels[currentStep - 1];

    return Semantics(
      label:
          'Langkah $currentStep dari ${bookingStepLabels.length} · $stepLabel',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: isWide
            ? Row(
                children: [
                  for (var i = 0; i < bookingStepLabels.length; i++) ...[
                    _Node(
                      index: i + 1,
                      label: bookingStepLabels[i],
                      state: _stateFor(i + 1),
                      ext: ext,
                      scheme: scheme,
                      textTheme: textTheme,
                    ),
                    if (i != bookingStepLabels.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: i + 1 < currentStep
                              ? ext.accent
                              : ext.borderDefault,
                        ),
                      ),
                  ],
                ],
              )
            : Row(
                children: [
                  for (var i = 0; i < bookingStepLabels.length; i++)
                    Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(
                          right: i != bookingStepLabels.length - 1 ? 4 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: i + 1 <= currentStep
                              ? ext.accent
                              : ext.borderDefault,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  _NodeState _stateFor(int index) {
    if (index < currentStep) return _NodeState.done;
    if (index == currentStep) return _NodeState.current;
    return _NodeState.upcoming;
  }
}

enum _NodeState { done, current, upcoming }

class _Node extends StatelessWidget {
  const _Node({
    required this.index,
    required this.label,
    required this.state,
    required this.ext,
    required this.scheme,
    required this.textTheme,
  });

  final int index;
  final String label;
  final _NodeState state;
  final TsThemeExtension ext;
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final isActive = state != _NodeState.upcoming;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? ext.accent : scheme.surfaceContainerLow,
          ),
          child: state == _NodeState.done
              ? Icon(Icons.check_rounded, size: 16, color: scheme.onPrimary)
              : Text(
                  '$index',
                  style: textTheme.labelSmall?.copyWith(
                    color: isActive ? scheme.onPrimary : ext.textFaint,
                  ),
                ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: isActive ? scheme.onSurface : ext.textFaint,
          ),
        ),
      ],
    );
  }
}
