import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/target_time_notifier.dart';
import '../utils/app_color_scheme.dart';

class EditTargetDialog {
  static void show(BuildContext context, TargetTimeNotifier targetTimeNotifier, Duration currentTarget) {
    final minutesController = TextEditingController(
      text: currentTarget.inMinutes.remainder(60).toString(),
    );
    final secondsController = TextEditingController(
      text: currentTarget.inSeconds.remainder(60).toString(),
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
              Icons.flag,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Edit Target Time',
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
              'Set the target time you want to reach:',
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
                    maxValue: 180, // Allow up to 3 hours
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
              'Quick presets:',
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
                _buildPresetButton(
                  context,
                  '15 min',
                  const Duration(minutes: 15),
                  targetTimeNotifier,
                ),
                _buildPresetButton(
                  context,
                  '30 min',
                  const Duration(minutes: 30),
                  targetTimeNotifier,
                ),
                _buildPresetButton(
                  context,
                  '45 min',
                  const Duration(minutes: 45),
                  targetTimeNotifier,
                ),
                _buildPresetButton(
                  context,
                  '1 hour',
                  const Duration(hours: 1),
                  targetTimeNotifier,
                ),
                _buildPresetButton(
                  context,
                  '1.5 hours',
                  const Duration(minutes: 90),
                  targetTimeNotifier,
                ),
                _buildPresetButton(
                  context,
                  '2 hours',
                  const Duration(hours: 2),
                  targetTimeNotifier,
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
          OutlinedButton(
            onPressed: () {
              final minutes = int.tryParse(minutesController.text) ?? 0;
              final seconds = int.tryParse(secondsController.text) ?? 0;
              final newTarget = Duration(minutes: minutes, seconds: seconds);
              targetTimeNotifier.updateTargetTime(newTarget);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              //textStyle: TextStyle(fontWeight: FontWeight.bold)
            ),
            child: const Text('Update Target'),
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
              LengthLimitingTextInputFormatter(3),
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

  static Widget _buildPresetButton(
      BuildContext context,
      String label,
      Duration duration,
      TargetTimeNotifier targetTimeNotifier,
      ) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: () {
          targetTimeNotifier.updateTargetTime(duration);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          foregroundColor: AppColors.neutral700,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}