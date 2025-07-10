import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/timer_data.dart';
import '../models/timer_state.dart';
import '../providers/timer_notifier.dart';
import '../dialogs/stop_confirmation_dialog.dart';
import '../dialogs/restart_confirmation_dialog.dart';
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Restart Button (Left)
        _buildSecondaryButton(
          context,
          icon: CupertinoIcons.restart,
          onTap: () => _showRestartConfirmation(context),
          color: AppColors.getTextSecondary(isDarkMode),
          isDarkMode: isDarkMode,
        ),

        const SizedBox(width: 32),

        // Primary Play/Pause Button (Center)
        _buildPrimaryButton(context, isDarkMode),

        const SizedBox(width: 32),

        // Stop Button (Right)
        _buildSecondaryButton(
          context,
          icon: CupertinoIcons.stop_fill,
          onTap: () => _showStopConfirmation(context),
          color: AppColors.danger,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context, bool isDarkMode) {
    final isRunning = timerData.state == TimerState.running;
    final isPaused = timerData.state == TimerState.paused;

    // Use theme-aware colors based on state
    Color buttonColor;
    IconData icon;

    if (isRunning) {
      buttonColor = AppColors.warning;
      icon = CupertinoIcons.pause_fill;
    } else if (isPaused) {
      buttonColor = AppColors.success;
      icon = CupertinoIcons.play_fill;
    } else {
      buttonColor = AppColors.primary;
      icon = CupertinoIcons.play_fill;
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(isDarkMode ? 0.4 : 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _toggleTimer(timerNotifier, timerData.state),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                buttonColor,
                buttonColor.withOpacity(0.8),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 36,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
      BuildContext context, {
        required IconData icon,
        required VoidCallback onTap,
        required Color color,
        required bool isDarkMode,
      }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.darkShadow
                : AppColors.softShadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.getSurface(isDarkMode),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(isDarkMode ? 0.4 : 0.2),
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
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

  void _showRestartConfirmation(BuildContext context) {
    RestartConfirmationDialog.show(context, timerNotifier, timerData);
  }

  void _showStopConfirmation(BuildContext context) {
    StopConfirmationDialog.show(context, timerNotifier, timerData);
  }
}