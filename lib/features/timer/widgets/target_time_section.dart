import 'package:flutter/material.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../providers/target_time_notifier.dart';
import '../dialogs/edit_target_dialog.dart';

class TargetTimeSection extends StatelessWidget {
  final Duration targetTime;
  final TargetTimeNotifier targetTimeNotifier;

  const TargetTimeSection({
    super.key,
    required this.targetTime,
    required this.targetTimeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => EditTargetDialog.show(context, targetTimeNotifier, targetTime),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Text("Time to"),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  targetTime.toMMSS(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.green,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.green.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}