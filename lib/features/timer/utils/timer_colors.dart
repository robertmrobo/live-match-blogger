import 'package:flutter/material.dart';
import '../models/timer_state.dart';

class TimerColors {
  static Color getTimerColor(TimerState state) {
    switch (state) {
      case TimerState.running:
        return Colors.green;
      case TimerState.paused:
        return Colors.orange;
      case TimerState.stopped:
        return Colors.grey;
    }
  }

  static Color getRemainingColor(Duration elapsed, Duration target) {
    final remaining = target - elapsed;
    if (remaining.isNegative) {
      return Colors.red.shade700;
    } else if (remaining.inMinutes <= 5) {
      return Colors.orange;
    } else {
      return Colors.red.shade600;
    }
  }

  static Color getProgressColor(double progress) {
    if (progress < 0.5) return Colors.green;
    if (progress < 0.8) return Colors.orange;
    return Colors.red;
  }
}