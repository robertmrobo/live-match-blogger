import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/timer_notifier.dart';
import '../utils/app_color_scheme.dart';

class EditTimerDialog {
  static void show(BuildContext context, TimerNotifier timerNotifier, Duration currentDuration) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final minutesController = TextEditingController(
      text: currentDuration.inMinutes.remainder(60).toString(),
    );
    final secondsController = TextEditingController(
      text: currentDuration.inSeconds.remainder(60).toString(),
    );

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
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Edit Timer',
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
          children: [
            Text(
              'Adjust the current timer duration:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.getTextSecondary(isDarkMode),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildTimeInput(
                    context: context,
                    controller: minutesController,
                    label: 'Minutes',
                    icon: Icons.access_time_outlined,
                    maxValue: 59,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeInput(
                    context: context,
                    controller: secondsController,
                    label: 'Seconds',
                    icon: Icons.timer_outlined,
                    maxValue: 59,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Quick adjustments:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextSecondary(isDarkMode),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickButton(
                  context,
                  '+1 min',
                      () => _addMinutes(minutesController, 1),
                  isDarkMode,
                ),
                _buildQuickButton(
                  context,
                  '+5 min',
                      () => _addMinutes(minutesController, 5),
                  isDarkMode,
                ),
                _buildQuickButton(
                  context,
                  '+10 min',
                      () => _addMinutes(minutesController, 10),
                  isDarkMode,
                ),
                _buildQuickButton(
                  context,
                  'Reset',
                      () => _resetFields(minutesController, secondsController),
                  isDarkMode,
                  isReset: true,
                ),
              ],
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
              final minutes = int.tryParse(minutesController.text) ?? 0;
              final seconds = int.tryParse(secondsController.text) ?? 0;
              final newDuration = Duration(minutes: minutes, seconds: seconds);
              timerNotifier.updateDuration(newDuration);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Update Timer'),
          ),
        ],
      ),
    );
  }

  static Widget _buildTimeInput({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int maxValue,
    required bool isDarkMode,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.getCardBorder(isDarkMode),
              width: 1.5,
            ),
            color: AppColors.getSurface(isDarkMode),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? AppColors.darkShadow : AppColors.softShadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimary(isDarkMode),
              fontFamily: 'monospace',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              hintText: '0',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.getTextMuted(isDarkMode),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
            onChanged: (value) {
              final intValue = int.tryParse(value) ?? 0;
              if (intValue > maxValue) {
                controller.text = maxValue.toString();
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  static Widget _buildQuickButton(
      BuildContext context,
      String text,
      VoidCallback onPressed,
      bool isDarkMode, {
        bool isReset = false,
      }) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isReset
              ? AppColors.warning.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          foregroundColor: isReset
              ? AppColors.warning
              : AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: isReset
                  ? AppColors.warning.withOpacity(0.3)
                  : AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: theme.textTheme.labelMedium?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static void _addMinutes(TextEditingController controller, int minutes) {
    final current = int.tryParse(controller.text) ?? 0;
    final newValue = (current + minutes).clamp(0, 59);
    controller.text = newValue.toString();
  }

  static void _resetFields(
      TextEditingController minutesController,
      TextEditingController secondsController,
      ) {
    minutesController.text = '0';
    secondsController.text = '0';
  }
}