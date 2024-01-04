import 'dart:async';
import 'package:mmh/providers/home_provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart';

class CountdownTimer {
  late Timer _timer;
  late TZDateTime _nextMidnight;
  final _timeRemainingController = StreamController<Duration>();
  late Location _local;
  late GameProvider gameProvider;

  CountdownTimer() {
    tzdata.initializeTimeZones();
    _local = getLocation('America/Sao_Paulo');

    _nextMidnight = _calculateNextMidnight();
    _startTimer();
  }

  TZDateTime _calculateNextMidnight() {
    final now = TZDateTime.now(_local);
    final nextMidnight = TZDateTime(_local, now.year, now.month, now.day + 1);
    return nextMidnight;
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final now = TZDateTime.now(_local);
        if (now.isAfter(_nextMidnight)) {
          _nextMidnight = _calculateNextMidnight();
          gameProvider.restartGame();
        }
        final timeRemaining = _nextMidnight.difference(now);
        _timeRemainingController.add(timeRemaining);
      },
    );
  }

  Stream<Duration> get stream => _timeRemainingController.stream;

  void dispose() {
    _timer.cancel();
    _timeRemainingController.close();
  }
}
