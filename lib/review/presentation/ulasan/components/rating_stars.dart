import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

const _maxStars = 5;

const _words = ['Buruk', 'Kurang', 'Cukup', 'Baik', 'Sangat baik'];

String ratingWord(int value) =>
    value >= 1 && value <= _maxStars ? _words[value - 1] : '';

enum RatingStarsSize {
  large(48, 36),
  compact(40, 28),
  display(20, 20);

  const RatingStarsSize(this.target, this.glyph);

  final double target;
  final double glyph;
}

class RatingStars extends StatefulWidget {
  const RatingStars.input({
    required int this.value,
    required ValueChanged<int> this.onChanged,
    required this.semanticLabel,
    super.key,
    this.size = RatingStarsSize.large,
  }) : _display = null;

  const RatingStars.display({
    required double value,
    super.key,
    this.size = RatingStarsSize.display,
    this.semanticLabel = 'Nilai',
  }) : value = null,
       onChanged = null,
       _display = value;

  final int? value;
  final ValueChanged<int>? onChanged;
  final double? _display;
  final String semanticLabel;
  final RatingStarsSize size;

  bool get isInput => onChanged != null;

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  bool _focused = false;

  int get _current => widget.value ?? 0;

  void _step(int delta) {
    final next = (_current + delta).clamp(1, _maxStars);
    if (next != _current) widget.onChanged!(next);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowUp) {
      _step(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowDown) {
      _step(-1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isInput ? _buildInput(context) : _buildDisplay(context);
  }

  Widget _buildDisplay(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final value = widget._display ?? 0;
    final size = widget.size.glyph;

    IconData iconFor(int index) {
      final remaining = value - index;
      if (remaining >= 0.75) return Icons.star_rounded;
      if (remaining >= 0.25) return Icons.star_half_rounded;
      return Icons.star_outline_rounded;
    }

    return Semantics(
      label: '${widget.semanticLabel} $value dari 5',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _maxStars; i++)
              Icon(
                iconFor(i),
                size: size,
                color: iconFor(i) == Icons.star_outline_rounded
                    ? ext.borderStrong
                    : ext.ratingStar,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final target = widget.size.target;

    return Focus(
      onFocusChange: (focused) => setState(() => _focused = focused),
      onKeyEvent: _onKey,
      child: Semantics(
        container: true,
        slider: true,
        label: widget.semanticLabel,
        value: _current == 0 ? 'Belum dinilai' : '$_current dari 5',
        increasedValue: '${(_current + 1).clamp(1, _maxStars)} dari 5',
        decreasedValue: '${(_current - 1).clamp(1, _maxStars)} dari 5',
        onIncrease: () => _step(1),
        onDecrease: () => _step(-1),
        child: ExcludeSemantics(
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _focused ? ext.focusRing : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 1; i <= _maxStars; i++)
                  SizedBox(
                    width: target,
                    height: target,
                    child: InkResponse(
                      key: ValueKey('rating_star_$i'),
                      radius: target / 2,
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () => widget.onChanged!(i),
                      child: AnimatedSwitcher(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 150),
                        child: Icon(
                          i <= _current
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          key: ValueKey(i <= _current),
                          size: widget.size.glyph,
                          color: i <= _current
                              ? ext.ratingStar
                              : ext.borderStrong,
                        ),
                      ),
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

class RatingLabel extends StatelessWidget {
  const RatingLabel({required this.value, super.key});

  final int value;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final text = value == 0
        ? 'Ketuk bintang untuk menilai'
        : '${ratingWord(value)} · $value dari 5';

    return Semantics(
      liveRegion: true,
      child: Text(
        text,
        style: textTheme.bodyMedium?.copyWith(
          color: value == 0 ? ext.textMuted : ext.textBody,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
