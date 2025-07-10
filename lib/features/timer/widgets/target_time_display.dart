
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../providers/target_time_notifier.dart';
import '../dialogs/edit_target_dialog.dart';
import '../utils/app_color_scheme.dart';

class TargetTimeDisplay extends ConsumerWidget {
  const TargetTimeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetTime = ref.watch(targetTimeProvider);
    final targetTimeNotifier = ref.read(targetTimeProvider.notifier);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Target time content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Target Time',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.getTextSecondary(isDarkMode),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              targetTime.toHHMMSS(),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimary(isDarkMode),
                fontFamily: 'monospace', // Better for time display
              ),
            ),
          ],
        ),

        const SizedBox(width: 16),

        // Edit button
        Container(
          decoration: BoxDecoration(
            color: AppColors.getSurface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.getCardBorder(isDarkMode),
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: () => EditTargetDialog.show(
              context,
              targetTimeNotifier,
              targetTime,
            ),
            icon: Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.getTextSecondary(isDarkMode),
              hoverColor: AppColors.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            tooltip: 'Edit target time',
          ),
        ),
      ],
    );
  }
}