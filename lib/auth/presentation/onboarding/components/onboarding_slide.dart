import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class OnboardingArt extends StatelessWidget {
  const OnboardingArt({required this.slide, this.maxArtWidth, super.key});

  final int slide;

  final double? maxArtWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: scheme.primaryContainer,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: FittedBox(
            child: SizedBox(
              width: maxArtWidth == null
                  ? constraints.maxWidth
                  : constraints.maxWidth.clamp(0, maxArtWidth!),
              child: switch (slide) {
                1 => const _MotorCardsVignette(),
                2 => const _TimelineVignette(),
                _ => const _TicketVignette(),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SilhouetteTile extends StatelessWidget {
  const _SilhouetteTile(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 40, color: ext.textBody),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: ext.successSoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.check_rounded, size: 14, color: ext.successText),
          ),
        ),
      ],
    );
  }
}

class _TicketVignette extends StatelessWidget {
  const _TicketVignette();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SilhouetteTile(Icons.two_wheeler_rounded),
            _SilhouetteTile(Icons.moped_rounded),
            _SilhouetteTile(Icons.sports_motorsports_rounded),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.confirmation_number_rounded,
                      size: 18,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Satu tiket untuk 3 motor',
                          style: textTheme.titleSmall?.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                        Text(
                          'Sel, 29 Sep · 09.00',
                          style: textTheme.bodySmall?.copyWith(
                            color: ext.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Wrap(
                spacing: 8,
                children: const [
                  _UnitPill('Unit -A'),
                  _UnitPill('Unit -B'),
                  _UnitPill('Unit -C'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnitPill extends StatelessWidget {
  const _UnitPill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: textTheme.labelSmall),
    );
  }
}

class _MotorCardsVignette extends StatelessWidget {
  const _MotorCardsVignette();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MotorCard(name: 'Vario 125', pills: ['Servis']),
        SizedBox(height: 12),
        _MotorCard(name: 'Beat 110', pills: ['Servis', 'Oli']),
        SizedBox(height: 12),
        _MotorCard(name: 'PCX 160', pills: ['Oli', 'Rem']),
      ],
    );
  }
}

class _MotorCard extends StatelessWidget {
  const _MotorCard({required this.name, required this.pills});

  final String name;
  final List<String> pills;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.two_wheeler_rounded,
              size: 24,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.titleSmall?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: pills.map((p) => _ServicePill(p)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicePill extends StatelessWidget {
  const _ServicePill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 12, color: scheme.onPrimaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: scheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineVignette extends StatelessWidget {
  const _TimelineVignette();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    Widget row(String name, UnitStatus status) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
            ),
          ),
          UnitStatusBadge(status: status),
        ],
      ),
    );

    Widget progressBar(double fraction) => Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          value: fraction,
          minHeight: 6,
          backgroundColor: scheme.surfaceContainerLow,
          valueColor: AlwaysStoppedAnimation(scheme.primary),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row('Vario 125', UnitStatus.selesai),
          row('Beat 110', UnitStatus.dikerjakan),
          row('PCX 160', UnitStatus.diperiksa),
          Row(
            children: [
              progressBar(1),
              const SizedBox(width: 6),
              progressBar(0.6),
              const SizedBox(width: 6),
              progressBar(0.3),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '1 selesai · 2 dalam proses',
            style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
          ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.count,
    required this.currentIndex,
    super.key,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Slide ${currentIndex + 1} dari $count',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (index) {
          final active = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(right: 6),
            width: active ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? scheme.primary : scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );
  }
}
