import 'package:live_match_blogger/features/timer/models/timer_state.dart';

class TimerData {
  final Duration duration;
  final TimerState state;

  const TimerData({
    required this.duration,
    required this.state,
  });

  TimerData copyWith({
    Duration? duration,
    TimerState? state,
  }) {
    return TimerData(
      duration: duration ?? this.duration,
      state: state ?? this.state,
    );
  }
}
