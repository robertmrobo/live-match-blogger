import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/target_time_notifier.dart';
import '../providers/timer_notifier.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../widgets/circular_progress_indicator.dart' as custom;
import '../widgets/target_time_display.dart';
import '../widgets/remaining_time_card.dart';
import '../widgets/quick_time_adjustment.dart';

class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({super.key});

  @override
  ConsumerState<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage> {
  bool _showQuickAdjustment = false;

  @override
  Widget build(BuildContext context) {
    final timerData = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    final targetTime = ref.watch(targetTimeProvider);
    final targetTimeNotifier = ref.read(targetTimeProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimerDisplay(
                    timerData: timerData,
                    targetTime: targetTime,
                    targetTimeNotifier: targetTimeNotifier,
                  ),
                  const SizedBox(height: 32),
                  custom.CircularProgressIndicator(
                    elapsed: timerData.duration,
                    target: targetTime,
                    size: 200,
                  ),
                  const SizedBox(height: 24),
                  const TargetTimeDisplay(),
                  const SizedBox(height: 32),
                  TimerControls(
                    timerData: timerData,
                    timerNotifier: timerNotifier,
                  ),
                  const SizedBox(height: 24),
                  RemainingTimeCard(
                    elapsed: timerData.duration,
                    target: targetTime,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_showQuickAdjustment) ...[
            QuickTimeAdjustment(
              onClose: () => setState(() => _showQuickAdjustment = false),
            ),
            const SizedBox(height: 16),
          ],
          FloatingActionButton(
            onPressed: () => setState(() => _showQuickAdjustment = !_showQuickAdjustment),
            child: AnimatedRotation(
              turns: _showQuickAdjustment ? 0.125 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(_showQuickAdjustment ? Icons.close : Icons.tune),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}