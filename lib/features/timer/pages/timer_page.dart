import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // Add this import

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

  bool get _isMobile {
    // Check if running on mobile platforms
    if (kIsWeb) return false;
    return Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    final timerData = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final targetTime = ref.watch(targetTimeProvider);
    final targetTimeNotifier = ref.read(targetTimeProvider.notifier);

    Widget content = Scaffold(
      backgroundColor: _isMobile ? null : Colors.transparent, // Make scaffold transparent on web
      appBar: AppBar(
        title: const Text(
          'Timer',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: _showSettingsSheet,
            icon: const Icon(
              CupertinoIcons.gear_alt,
              size: 22,
            ),
            style: IconButton.styleFrom(
              foregroundColor: Colors.blue,
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
                  TimerControls(
                    timerData: timerData,
                    timerNotifier: timerNotifier,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: RemainingTimeCard(
                      elapsed: timerData.duration,
                      target: targetTime,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // If not on mobile, wrap with rounded container and add outer scaffold
    if (!_isMobile) {
      content = Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: content,
            ),
          ),
        ),
      );
    }

    return content;
  }
}