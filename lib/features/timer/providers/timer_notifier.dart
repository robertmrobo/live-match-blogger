import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/timer_data.dart';
import '../models/timer_state.dart';

class TimerNotifier extends StateNotifier<TimerData> {
  Timer? _timer;

  TimerNotifier() : super(const TimerData(
    duration: Duration.zero,
    state: TimerState.stopped,
  ));

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void start() {
    if (state.state == TimerState.running) return;

    state = state.copyWith(state: TimerState.running);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        duration: state.duration + const Duration(seconds: 1),
      );
    });
  }

  void pause() {
    if (state.state != TimerState.running) return;

    _timer?.cancel();
    state = state.copyWith(state: TimerState.paused);
  }

  void stop() {
    _timer?.cancel();
    state = const TimerData(
      duration: Duration.zero,
      state: TimerState.stopped,
    );
  }

  void resume() {
    if (state.state != TimerState.paused) return;
    start();
  }

  void updateDuration(Duration newDuration) {
    state = state.copyWith(duration: newDuration);
  }

  void addTime(Duration additionalTime) {
    state = state.copyWith(
      duration: state.duration + additionalTime,
    );
  }

  void subtractTime(Duration timeToSubtract) {
    final newDuration = state.duration - timeToSubtract;
    state = state.copyWith(
      duration: newDuration.isNegative ? Duration.zero : newDuration,
    );
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerData>((ref) {
  return TimerNotifier();
});
