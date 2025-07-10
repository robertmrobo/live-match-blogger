
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/cupertino.dart';

import '../providers/target_time_notifier.dart';
import '../providers/timer_notifier.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../widgets/circular_progress_indicator.dart' as custom;
import '../widgets/target_time_display.dart';
import '../widgets/remaining_time_card.dart';
import '../widgets/timer_settings_sheet.dart';

class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({super.key});

  @override
  ConsumerState<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage> {

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TimerSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerData = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final targetTime = ref.watch(targetTimeProvider);
    final targetTimeNotifier = ref.read(targetTimeProvider.notifier);

    return Scaffold(
      // iOS-style navigation bar
      appBar: AppBar(
        title: const Text(
          'Timer',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17, // iOS standard title size
          ),
        ),
        centerTitle: true, // iOS centers titles
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          // iOS-style settings button
          IconButton(
            onPressed: _showSettingsSheet,
            icon: const Icon(
              CupertinoIcons.gear_alt,
              size: 22,
            ),
            style: IconButton.styleFrom(
              foregroundColor: Colors.blue, // iOS blue
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimerDisplay(
                    timerData: timerData,
                    targetTime: targetTime,
                    targetTimeNotifier: targetTimeNotifier,
                  ),
                  const SizedBox(height: 40),
                  custom.CircularProgressIndicator(
                    elapsed: timerData.duration,
                    target: targetTime,
                    size: 220,
                  ),
                  const SizedBox(height: 32),
                  const TargetTimeDisplay(),
                  const SizedBox(height: 40),
                  // Simplified controls - only essential buttons
                  TimerControls(
                    timerData: timerData,
                    timerNotifier: timerNotifier,
                  ),
                  const SizedBox(height: 32),
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
    );
  }
}