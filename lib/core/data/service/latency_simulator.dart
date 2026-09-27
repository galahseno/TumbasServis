import 'dart:math';

abstract class LatencySimulator {
  Future<void> simulate();
}

class RandomLatencySimulator implements LatencySimulator {
  RandomLatencySimulator({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const _minMs = 300;
  static const _rangeMs = 501;

  @override
  Future<void> simulate() => Future<void>.delayed(
    Duration(milliseconds: _minMs + _random.nextInt(_rangeMs)),
  );
}
