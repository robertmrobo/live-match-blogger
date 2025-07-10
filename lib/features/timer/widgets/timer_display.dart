import 'package:flutter/material.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../models/timer_data.dart';
import '../utils/app_color_scheme.dart';

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final timerStateColor = AppColors.getTimerStateColor(timerData.state.toString());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main timer display
        Text(
          timerData.duration.toHHMMSS(),
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(isDarkMode),
            letterSpacing: 2.0, // Better spacing for timer digits
          ),
        ),
        const SizedBox(height: 12),

        // State indicator with colored background
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: timerStateColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: timerStateColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // State indicator dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: timerStateColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _getStateText(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: timerStateColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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