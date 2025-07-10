
import 'package:flutter/material.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../utils/timer_calculations.dart';
import '../utils/app_color_scheme.dart';

class RemainingTimeCard extends StatelessWidget {
  final Duration elapsed;
  final Duration target;

  const RemainingTimeCard({
    super.key,
    required this.elapsed,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = TimerCalculations.calculateRemaining(elapsed, target);
    final isOvertime = elapsed > target;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get appropriate colors based on state
    final remainingColor = AppColors.getRemainingTimeColor(elapsed, target);
    final iconColor = isOvertime ? AppColors.danger : remainingColor;

    return Card(
      elevation: isDarkMode ? 8 : 4,
      shadowColor: isDarkMode ? AppColors.darkShadow : AppColors.softShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.getCardBackground(isDarkMode),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isDarkMode
              ? AppColors.darkCardGradient
              : AppColors.cardGradient,
          border: Border.all(
            color: AppColors.getCardBorder(isDarkMode),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Header row with icon and label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isOvertime ? Icons.timer_off_outlined : Icons.timer_outlined,
                    size: 20,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isOvertime ? 'Overtime' : 'Remaining',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(isDarkMode),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Main time display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: remainingColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: remainingColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                remaining.toHHMMSS(),
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: remainingColor,
                  fontFamily: 'monospace', // Better for time display
                  letterSpacing: 2.0,
                ),
              ),
            ),

            if (isOvertime) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.danger.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_outlined,
                      size: 16,
                      color: AppColors.danger,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'You\'ve exceeded your target time',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: AppColors.danger,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}