import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class _Shimmer extends StatefulWidget {
  const _Shimmer({required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    if (disableAnimations) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: ext.skeletonBase,
          borderRadius: widget.borderRadius,
        ),
        child: const SizedBox.expand(),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return ClipRRect(
          borderRadius: widget.borderRadius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + 3 * t, 0),
                end: Alignment(1 + 3 * t, 0),
                colors: [
                  ext.skeletonBase,
                  ext.skeletonHighlight,
                  ext.skeletonBase,
                ],
                stops: const [0.35, 0.5, 0.65],
              ),
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.width, this.height = 14});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: _Shimmer(borderRadius: BorderRadius.circular(4)),
    );
  }
}

class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({
    super.key,
    this.width,
    this.height = 64,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: _Shimmer(borderRadius: borderRadius),
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  const SkeletonAvatar({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: _Shimmer(borderRadius: BorderRadius.circular(size / 2)),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SkeletonAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonLine(width: 160),
                SizedBox(height: 8),
                SkeletonLine(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
