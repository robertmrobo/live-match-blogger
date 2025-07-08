import 'package:hooks_riverpod/hooks_riverpod.dart';

class TargetTimeNotifier extends StateNotifier<Duration> {
  TargetTimeNotifier() : super(const Duration(minutes: 45));

  void updateTargetTime(Duration newTarget) {
    state = newTarget;
  }

  void addTime(Duration additionalTime) {
    state = state + additionalTime;
  }

  void subtractTime(Duration timeToSubtract) {
    final newDuration = state - timeToSubtract;
    state = newDuration.isNegative ? Duration.zero : newDuration;
  }
}

final targetTimeProvider = StateNotifierProvider<TargetTimeNotifier, Duration>((ref) {
  return TargetTimeNotifier();
});

