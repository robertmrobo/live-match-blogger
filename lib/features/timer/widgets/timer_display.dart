import 'package:flutter/material.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../models/timer_data.dart';

class TimerDisplay extends StatelessWidget {
  final TimerData timerData;
  final Duration targetTime;
  final dynamic targetTimeNotifier;

  const TimerDisplay({
    super.key,
    required this.timerData,
    required this.targetTime,
    required this.targetTimeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          timerData.duration.toHHMMSS(),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getStateText(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _getStateText() {
    switch (timerData.state.toString()) {
      case 'TimerState.running':
        return 'Running';
      case 'TimerState.paused':
        return 'Paused';
      case 'TimerState.stopped':
        return 'Stopped';
      default:
        return 'Ready';
    }
  }
}