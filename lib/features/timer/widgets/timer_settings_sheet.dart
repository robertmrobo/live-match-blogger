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
import '../utils/app_color_scheme.dart';

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final timerData = ref.watch(timerProvider);
    final targetTime = ref.watch(targetTimeProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final targetTimeNotifier = ref.read(targetTimeProvider.notifier);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9, // Limit height to 90% of screen
        ),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(isDarkMode),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: AppColors.getCardBorder(isDarkMode),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? AppColors.darkShadow : AppColors.softShadow,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fixed header section
            Column(
              children: [
                const SizedBox(height: 24),
                // iOS-style handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: AppColors.getTextMuted(isDarkMode),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Timer Settings',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getTextPrimary(isDarkMode),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Done',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.danger,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                _buildCurrentValuesDisplay(timerData.duration, targetTime, isDarkMode),

                // iOS-style segmented control
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoSegmentedControl<SettingsTab>(
                    selectedColor: AppColors.primary,
                    unselectedColor: AppColors.getSurface(isDarkMode),
                    borderColor: AppColors.getCardBorder(isDarkMode),
                    pressedColor: AppColors.primary.withOpacity(0.2),
                    children: {
                      SettingsTab.adjustments: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: Text(
                          'Quick Adjust',
                          style: TextStyle(
                            color: _selectedTab == SettingsTab.adjustments
                                ? Colors.white
                                : AppColors.getTextPrimary(isDarkMode),
                          ),
                        ),
                      ),
                      SettingsTab.actions: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: Text(
                          'Actions',
                          style: TextStyle(
                            color: _selectedTab == SettingsTab.actions
                                ? Colors.white
                                : AppColors.getTextPrimary(isDarkMode),
                          ),
                        ),
                      ),
                    },
                    groupValue: _selectedTab,
                    onValueChanged: (value) {
                      setState(() => _selectedTab = value);
                    },
                  ),
                ),
              ],
            ),

            // Scrollable content section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _selectedTab == SettingsTab.adjustments
                    ? _buildAdjustmentsTab(timerNotifier, targetTimeNotifier, isDarkMode)
                    : _buildActionsTab(timerData, timerNotifier, isDarkMode),
              ),
            ),

            // Add some bottom padding to ensure content doesn't get cut off
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentValuesDisplay(Duration currentTimer, Duration targetTime, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.getCardBorder(isDarkMode),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppColors.darkShadow : AppColors.softShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
                    color: AppColors.getTextSecondary(isDarkMode),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentTimer.toHHMMSS(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(isDarkMode),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 40,
            color: AppColors.getCardBorder(isDarkMode),
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
                    color: AppColors.getTextSecondary(isDarkMode),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  targetTime.toHHMMSS(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(isDarkMode),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentsTab(TimerNotifier timerNotifier, dynamic targetTimeNotifier, bool isDarkMode) {
    return Column(
      children: [
        // Timer Adjustments Section
        _buildSectionHeader('Timer Adjustments', isDarkMode),
        const SizedBox(height: 12),
        _buildAdjustmentGrid([
          _AdjustmentButton(
            label: '-5 min',
            onTap: () => timerNotifier.subtractTime(const Duration(minutes: 5)),
            color: AppColors.danger,
          ),
          _AdjustmentButton(
            label: '-1 min',
            onTap: () => timerNotifier.subtractTime(const Duration(minutes: 1)),
            color: AppColors.warning,
          ),
          _AdjustmentButton(
            label: '+1 min',
            onTap: () => timerNotifier.addTime(const Duration(minutes: 1)),
            color: AppColors.success,
          ),
          _AdjustmentButton(
            label: '+5 min',
            onTap: () => timerNotifier.addTime(const Duration(minutes: 5)),
            color: AppColors.danger,
          ),
        ], isDarkMode),

        const SizedBox(height: 24),

        // Target Time Adjustments Section
        _buildSectionHeader('Target Time Adjustments', isDarkMode),
        const SizedBox(height: 12),
        _buildAdjustmentGrid([
          _AdjustmentButton(
            label: '-30 min',
            onTap: () => targetTimeNotifier.subtractTime(const Duration(minutes: 30)),
            color: AppColors.warning,
          ),
          _AdjustmentButton(
            label: '-15 min',
            onTap: () => targetTimeNotifier.subtractTime(const Duration(minutes: 15)),
            color: AppColors.info,
          ),
          _AdjustmentButton(
            label: '+15 min',
            onTap: () => targetTimeNotifier.addTime(const Duration(minutes: 15)),
            color: AppColors.success,
          ),
          _AdjustmentButton(
            label: '+30 min',
            onTap: () => targetTimeNotifier.addTime(const Duration(minutes: 30)),
            color: AppColors.danger,
          ),
        ], isDarkMode),
      ],
    );
  }

  Widget _buildActionsTab(TimerData timerData, TimerNotifier timerNotifier, bool isDarkMode) {
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
          isDarkMode: isDarkMode,
        ),

        const SizedBox(height: 12),

        _buildActionButton(
          icon: CupertinoIcons.doc_on_doc,
          title: 'Copy Timer',
          subtitle: 'Copy current time to clipboard',
          onTap: () => _copyToClipboard(timerData.duration),
          isDarkMode: isDarkMode,
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
          isDarkMode: isDarkMode,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.getTextSecondary(isDarkMode),
        ),
      ),
    );
  }

  Widget _buildAdjustmentGrid(List<_AdjustmentButton> buttons, bool isDarkMode) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: buttons.map((button) => _buildAdjustmentTile(button, isDarkMode)).toList(),
    );
  }

  Widget _buildAdjustmentTile(_AdjustmentButton button, bool isDarkMode) {
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
    required bool isDarkMode,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getSurface(isDarkMode),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.getCardBorder(isDarkMode),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? AppColors.darkShadow : AppColors.softShadow,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.danger.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? AppColors.danger : AppColors.primary,
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
                      color: isDestructive
                          ? AppColors.danger
                          : AppColors.getTextPrimary(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.getTextMuted(isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(Duration duration) {
    Clipboard.setData(ClipboardData(text: duration.toHHMMSS()));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Timer copied: ${duration.toHHMMSS()}'),
        backgroundColor: AppColors.success,
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