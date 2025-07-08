import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../models/timer_data.dart';
import '../models/timer_state.dart';
import '../providers/timer_notifier.dart';
import '../dialogs/edit_timer_dialog.dart';
import '../dialogs/stop_confirmation_dialog.dart';
import '../utils/app_color_scheme.dart';

class TimerControls extends StatelessWidget {
  final TimerData timerData;
  final TimerNotifier timerNotifier;

  const TimerControls({
    super.key,
    required this.timerData,
    required this.timerNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildControlButton(
          icon: timerData.state == TimerState.running
              ? Icons.pause
              : Icons.play_arrow,
          onPressed: () => _toggleTimer(timerNotifier, timerData.state),
          color: timerData.state == TimerState.running
              ? AppColors.warning
              : AppColors.success,
          size: 48,
        ),
        const SizedBox(width: 16),
        _buildControlButton(
          icon: Icons.edit,
          onPressed: () => EditTimerDialog.show(context, timerNotifier, timerData.duration),
          color: AppColors.primary,
          size: 48,
        ),
        const SizedBox(width: 16),
        _buildControlButton(
          icon: Icons.content_copy_rounded,
          onPressed: () => _copyToClipboard(context, timerData.duration),
          color: AppColors.neutral500,
          size: 48,
        ),
        const SizedBox(width: 16),
        _buildControlButton(
          icon: Icons.stop_outlined,
          onPressed: () => StopConfirmationDialog.show(context, timerNotifier, timerData),
          color: AppColors.danger,
          size: 48,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required double size,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: size),
        color: color,
        splashRadius: size / 4,
        style: IconButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  void _toggleTimer(TimerNotifier timerNotifier, TimerState currentState) {
    switch (currentState) {
      case TimerState.stopped:
        timerNotifier.start();
        break;
      case TimerState.running:
        timerNotifier.pause();
        break;
      case TimerState.paused:
        timerNotifier.resume();
        break;
    }
  }

  void _copyToClipboard(BuildContext context, Duration duration) {
    Clipboard.setData(ClipboardData(text: duration.toMMSS()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Timer copied: ${duration.toMMSS()}'),
        backgroundColor: AppColors.neutral700,
      ),
    );
  }
}