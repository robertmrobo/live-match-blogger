import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/timer_data.dart';
import '../models/timer_state.dart';
import '../providers/timer_notifier.dart';
import '../dialogs/stop_confirmation_dialog.dart';
import '../dialogs/restart_confirmation_dialog.dart';

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
        // Restart Button (Left)
        _buildSecondaryButton(
          icon: CupertinoIcons.restart,
          onTap: () => _showRestartConfirmation(context),
          color: Colors.grey.shade600,
        ),

        const SizedBox(width: 32),

        // Primary Play/Pause Button (Center)
        _buildPrimaryButton(),

        const SizedBox(width: 32),

        // Stop Button (Right)
        _buildSecondaryButton(
          icon: CupertinoIcons.stop_fill,
          onTap: () => _showStopConfirmation(context),
          color: Colors.red.shade500,
        ),
      ],
    );
  }

  Widget _buildPrimaryButton() {
    final isRunning = timerData.state == TimerState.running;
    final color = isRunning ? Colors.orange : Colors.blue;
    final icon = isRunning ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
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
            color: color,
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

  Widget _buildSecondaryButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.2),
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