import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';

import '../providers/timer_notifier.dart';
import '../providers/target_time_notifier.dart';
import '../models/timer_data.dart';
import '../dialogs/edit_timer_dialog.dart';
import '../dialogs/stop_confirmation_dialog.dart';

enum SettingsTab { adjustments, actions }

class TimerSettingsSheet extends ConsumerStatefulWidget {
  const TimerSettingsSheet({super.key});

  @override
  ConsumerState<TimerSettingsSheet> createState() => _TimerSettingsSheetState();
}

class _TimerSettingsSheetState extends ConsumerState<TimerSettingsSheet>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  SettingsTab _selectedTab = SettingsTab.adjustments;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerData = ref.watch(timerProvider);
    final targetTime = ref.watch(targetTimeProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final targetTimeNotifier = ref.read(targetTimeProvider.notifier);

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 32),
            // iOS-style handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Timer Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Current Values Display
            if (_selectedTab == SettingsTab.adjustments)
              _buildCurrentValuesDisplay(timerData.duration, targetTime),

            // iOS-style segmented control
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CupertinoSegmentedControl<SettingsTab>(
                children: const {
                  SettingsTab.adjustments: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text('Quick Adjust'),
                  ),
                  SettingsTab.actions: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text('Actions'),
                  ),
                },
                groupValue: _selectedTab,
                onValueChanged: (value) {
                  setState(() => _selectedTab = value);
                },
              ),
            ),

            // Content based on selected tab
            Flexible(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: _selectedTab == SettingsTab.adjustments
                    ? _buildAdjustmentsTab(timerNotifier, targetTimeNotifier)
                    : _buildActionsTab(timerData, timerNotifier),
              ),
            ),

            // Add some bottom padding to ensure content doesn't get cut off
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentValuesDisplay(Duration currentTimer, Duration targetTime) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Timer Display
          Expanded(
            child: Column(
              children: [
                Text(
                  'Current Timer',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentTimer.toMMSS(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),

          // Target Time Display
          Expanded(
            child: Column(
              children: [
                Text(
                  'Target Time',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  targetTime.toMMSS(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentsTab(TimerNotifier timerNotifier, dynamic targetTimeNotifier) {
    return Column(
      children: [
        // Timer Adjustments Section
        _buildSectionHeader('Timer Adjustments'),
        const SizedBox(height: 12),
        _buildAdjustmentGrid([
          _AdjustmentButton(
            label: '-5 min',
            onTap: () => timerNotifier.subtractTime(const Duration(minutes: 5)),
            color: Colors.red.shade400,
          ),
          _AdjustmentButton(
            label: '-1 min',
            onTap: () => timerNotifier.subtractTime(const Duration(minutes: 1)),
            color: Colors.red.shade300,
          ),
          _AdjustmentButton(
            label: '+1 min',
            onTap: () => timerNotifier.addTime(const Duration(minutes: 1)),
            color: Colors.green.shade400,
          ),
          _AdjustmentButton(
            label: '+5 min',
            onTap: () => timerNotifier.addTime(const Duration(minutes: 5)),
            color: Colors.green.shade500,
          ),
        ]),

        const SizedBox(height: 24),

        // Target Time Adjustments Section
        _buildSectionHeader('Target Time Adjustments'),
        const SizedBox(height: 12),
        _buildAdjustmentGrid([
          _AdjustmentButton(
            label: '-30 min',
            onTap: () => targetTimeNotifier.subtractTime(const Duration(minutes: 30)),
            color: Colors.orange.shade400,
          ),
          _AdjustmentButton(
            label: '-15 min',
            onTap: () => targetTimeNotifier.subtractTime(const Duration(minutes: 15)),
            color: Colors.orange.shade300,
          ),
          _AdjustmentButton(
            label: '+15 min',
            onTap: () => targetTimeNotifier.addTime(const Duration(minutes: 15)),
            color: Colors.blue.shade400,
          ),
          _AdjustmentButton(
            label: '+30 min',
            onTap: () => targetTimeNotifier.addTime(const Duration(minutes: 30)),
            color: Colors.blue.shade500,
          ),
        ]),
      ],
    );
  }

  Widget _buildActionsTab(TimerData timerData, TimerNotifier timerNotifier) {
    return Column(
      children: [
        // iOS-style action buttons
        _buildActionButton(
          icon: CupertinoIcons.pencil,
          title: 'Edit Timer',
          subtitle: 'Manually set timer duration',
          onTap: () {
            Navigator.pop(context);
            EditTimerDialog.show(context, timerNotifier, timerData.duration);
          },
        ),

        const SizedBox(height: 12),

        _buildActionButton(
          icon: CupertinoIcons.doc_on_doc,
          title: 'Copy Timer',
          subtitle: 'Copy current time to clipboard',
          onTap: () => _copyToClipboard(timerData.duration),
        ),

        const SizedBox(height: 12),

        _buildActionButton(
          icon: CupertinoIcons.stop_circle,
          title: 'Stop Timer',
          subtitle: 'Reset timer to 00:00',
          onTap: () {
            Navigator.pop(context);
            StopConfirmationDialog.show(context, timerNotifier, timerData);
          },
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildAdjustmentGrid(List<_AdjustmentButton> buttons) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: buttons.map((button) => _buildAdjustmentTile(button)).toList(),
    );
  }

  Widget _buildAdjustmentTile(_AdjustmentButton button) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: button.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: button.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: button.onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: button.color.withOpacity(0.2),
          highlightColor: button.color.withOpacity(0.1),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Text(
                button.label,
                style: TextStyle(
                  color: button.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.shade50
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? Colors.red : Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.red : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(Duration duration) {
    Clipboard.setData(ClipboardData(text: duration.toMMSS()));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Timer copied: ${duration.toMMSS()}'),
        backgroundColor: Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _AdjustmentButton {
  final String label;
  final VoidCallback onTap;
  final Color color;

  _AdjustmentButton({
    required this.label,
    required this.onTap,
    required this.color,
  });
}