import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class _PromoCopy {
  const _PromoCopy(this.body, this.ctaLabel, this.icon);

  final String body;
  final String ctaLabel;
  final IconData icon;
}

const _copyById = <String, _PromoCopy>{
  'promo_diskon10': _PromoCopy(
    'Satu booking, banyak motor, hemat langsung Rp42.800.',
    'Pakai voucher',
    Icons.sell_rounded,
  ),
  'promo_multi_motor': _PromoCopy(
    'Semua motor selesai dalam satu kunjungan bengkel.',
    'Booking sekarang',
    Icons.two_wheeler_rounded,
  ),
  'promo_servis_reminder': _PromoCopy(
    'Servis berkala tepat waktu, motor selalu prima.',
    'Booking sekarang',
    Icons.notifications_active_rounded,
  ),
};

_PromoCopy _copyFor(Promo promo) =>
    _copyById[promo.id] ??
    const _PromoCopy('', 'Booking sekarang', Icons.local_offer_rounded);

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({required this.promos, super.key, this.onTapPromo});

  final List<Promo> promos;
  final void Function(Promo promo)? onTapPromo;

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _page = 0;
  bool _paused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleNext() {
    _timer?.cancel();
    if (_paused || widget.promos.length <= 1) return;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return;
    _timer = Timer(const Duration(seconds: 5), () {
      final next = (_page + 1) % widget.promos.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _setPaused(bool paused) {
    if (_paused == paused) return;
    setState(() => _paused = paused);
    _scheduleNext();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.promos.isEmpty) return const SizedBox.shrink();

    return Focus(
      onFocusChange: _setPaused,
      child: MouseRegion(
        onEnter: (_) => _setPaused(true),
        onExit: (_) => _setPaused(false),
        child: Listener(
          onPointerDown: (_) => _setPaused(true),
          onPointerUp: (_) => _setPaused(false),
          child: Semantics(
            label: 'Promo ${_page + 1} dari ${widget.promos.length}',
            child: Column(
              children: [
                SizedBox(
                  height: 148,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: widget.promos.length,
                    onPageChanged: (page) {
                      setState(() => _page = page);
                      _scheduleNext();
                    },
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _PromoSlide(
                        promo: widget.promos[index],
                        onTap: widget.onTapPromo == null
                            ? null
                            : () => widget.onTapPromo!(widget.promos[index]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ExcludeSemantics(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < widget.promos.length; i++)
                        _Dot(active: i == _page),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PromoSlide extends StatelessWidget {
  const _PromoSlide({required this.promo, this.onTap});

  final Promo promo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final copy = _copyFor(promo);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [scheme.primaryContainer, scheme.surfaceContainer],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -12,
              bottom: -12,
              child: Icon(
                copy.icon,
                size: 72,
                color: scheme.primary.withValues(alpha: 0.16),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promo.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  copy.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(color: ext.textBody),
                ),
                const SizedBox(height: 12),
                TsButton(
                  label: copy.ctaLabel,
                  onPressed: onTap,
                  type: TsButtonType.primary,
                  compact: true,
                  fullWidth: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 16 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? scheme.primary : ext.borderDefault,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
