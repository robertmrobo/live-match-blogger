class TimerCalculations {
  static Duration calculateRemaining(Duration elapsed, Duration target) {
    final remaining = target - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  static double calculateProgress(Duration elapsed, Duration target) {
    if (target == Duration.zero) return 0.0;
    final progress = elapsed.inSeconds / target.inSeconds;
    return progress.clamp(0.0, 1.0);
  }
}