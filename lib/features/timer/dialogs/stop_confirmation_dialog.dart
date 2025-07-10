import 'package:flutter/material.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../models/timer_data.dart';
import '../models/timer_state.dart';
import '../providers/timer_notifier.dart';
import '../utils/app_color_scheme.dart';

class StopConfirmationDialog {
  static void show(BuildContext context, TimerNotifier timerNotifier, TimerData timerData) {
    if (timerData.state == TimerState.stopped && timerData.duration == Duration.zero) {
      return;
    }

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getCardBackground(isDarkMode),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.getCardBorder(isDarkMode),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.stop_circle_outlined,
                color: AppColors.danger,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Stop Timer',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to stop the timer?',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
            ),
            const SizedBox(height: 20),

            // Current time display
            Container(
              width: double.infinity,
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.timer_outlined,
                      color: AppColors.warning,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current time',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.getTextSecondary(isDarkMode),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          timerData.duration.toHHMMSS(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.getTextPrimary(isDarkMode),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Warning message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.danger.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_outlined,
                    color: AppColors.danger,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This will reset the timer to 00:00 and cannot be undone.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.danger,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.getTextSecondary(isDarkMode),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              timerNotifier.stop();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Stop Timer'),
          ),
        ],
      ),
    );
  }
}