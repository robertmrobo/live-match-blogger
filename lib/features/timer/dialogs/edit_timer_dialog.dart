import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/timer_notifier.dart';
import '../utils/app_color_scheme.dart';

class EditTimerDialog {
  static void show(BuildContext context, TimerNotifier timerNotifier, Duration currentDuration) {
    final minutesController = TextEditingController(
      text: currentDuration.inMinutes.remainder(60).toString(),
    );
    final secondsController = TextEditingController(
      text: currentDuration.inSeconds.remainder(60).toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.edit,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Edit Timer',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Adjust the current timer duration:',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.neutral500,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildTimeInput(
                    controller: minutesController,
                    label: 'Minutes',
                    icon: Icons.access_time,
                    maxValue: 59,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeInput(
                    controller: secondsController,
                    label: 'Seconds',
                    icon: Icons.timer,
                    maxValue: 59,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Quick adjustments:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral500,
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
                ),
                _buildQuickButton(
                  context,
                  '+5 min',
                      () => _addMinutes(minutesController, 5),
                ),
                _buildQuickButton(
                  context,
                  '+10 min',
                      () => _addMinutes(minutesController, 10),
                ),
                _buildQuickButton(
                  context,
                  'Reset',
                      () => _resetFields(minutesController, secondsController),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
            child: const Text('Update Timer'),
          ),
        ],
      ),
    );
  }

  static Widget _buildTimeInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int maxValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // iOS-style label above the input
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral600,
            ),
          ),
        ),
        // Input field without label
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.neutral300),
            color: AppColors.neutral50,
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              hintText: '0',
              hintStyle: TextStyle(
                color: AppColors.neutral400,
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
      ) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
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