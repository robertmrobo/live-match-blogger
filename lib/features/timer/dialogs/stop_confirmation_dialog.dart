import 'package:flutter/material.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../models/timer_data.dart';
import '../models/timer_state.dart';
import '../providers/timer_notifier.dart';

class StopConfirmationDialog {
  static void show(BuildContext context, TimerNotifier timerNotifier, TimerData timerData) {
    if (timerData.state == TimerState.stopped && timerData.duration == Duration.zero) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Timer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to stop the timer?'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    'Current time: ${timerData.duration.toMMSS()}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This will reset the timer to 00:00 and cannot be undone.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              timerNotifier.stop();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Stop Timer'),
          ),
        ],
      ),
    );
  }
}