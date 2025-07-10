import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';

import '../models/timer_data.dart';
import '../providers/timer_notifier.dart';

class RestartConfirmationDialog {
  static void show(
      BuildContext context,
      TimerNotifier timerNotifier,
      TimerData timerData,
      ) {
    showDialog(
      context: context,
      builder: (context) => _RestartConfirmationDialog(
        timerNotifier: timerNotifier,
        timerData: timerData,
      ),
    );
  }
}

class _RestartConfirmationDialog extends StatelessWidget {
  final TimerNotifier timerNotifier;
  final TimerData timerData;

  const _RestartConfirmationDialog({
    required this.timerNotifier,
    required this.timerData,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Restart Timer?'),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'This will reset your current timer (${timerData.duration.toMMSS()}) back to 00:00 and start immediately.',
          style: const TextStyle(fontSize: 14),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Restart'),
          onPressed: () {
            Navigator.of(context).pop();
            _restartTimer();
          },
        ),
      ],
    );
  }

  void _restartTimer() {
    timerNotifier.stop();
    timerNotifier.start();
  }
}