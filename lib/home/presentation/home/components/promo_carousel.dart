import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

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
  const PromoCarousel({
    required this.promos,
    super.key,
    this.onTapPromo,
    this.perView = 1,
  });

  final List<Promo> promos;

  final int perView;
  final void Function(Promo promo)? onTapPromo;

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: _viewportFraction,
  );
  Timer? _timer;
  int _page = 0;

  bool get _multiUp => widget.perView > 1;
  double get _viewportFraction => _multiUp ? 1 / widget.perView : 0.92;

  int get _pageCount => math.max(1, widget.promos.length - widget.perView + 1);
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
    if (_paused || _pageCount <= 1) return;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return;
    _timer = Timer(const Duration(seconds: 5), () {
      final next = (_page + 1) % _pageCount;
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

  double _slideHeight(BuildContext context) {
    final factor = MediaQuery.textScalerOf(context).scale(1);
    final narrow = context.windowSizeClass.isCompact || widget.perView > 1;
    return (narrow ? 180 : 148) + (factor.clamp(1.0, 2.0) - 1) * 112;
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
            label: 'Promo ${_page + 1} dari $_pageCount',
            child: Column(
              children: [
                SizedBox(
                  height: _slideHeight(context),
                  child: PageView.builder(
                    controller: _controller,
                    padEnds: !_multiUp,
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
                      for (var i = 0; i < _pageCount; i++)
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
        clipBehavior: Clip.hardEdge,
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
            LayoutBuilder(
              builder: (context, constraints) => constraints.maxWidth < 120
                  ? const SizedBox.shrink()
                  : Column(
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
                          style: textTheme.bodySmall?.copyWith(
                            color: ext.textBody,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IntrinsicWidth(
                            child: TsButton(
                              label: copy.ctaLabel,
                              onPressed: onTap,
                              type: TsButtonType.primary,
                              compact: true,
                              fullWidth: false,
                            ),
                          ),
                        ),
                      ],
                    ),
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
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
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
