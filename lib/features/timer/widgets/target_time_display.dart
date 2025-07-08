import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../providers/target_time_notifier.dart';
import '../dialogs/edit_target_dialog.dart';

class TargetTimeDisplay extends ConsumerWidget {
  const TargetTimeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetTime = ref.watch(targetTimeProvider);
    final targetTimeNotifier = ref.read(targetTimeProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Target: ${targetTime.toMMSS()}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () => EditTargetDialog.show(
            context,
            targetTimeNotifier,
            targetTime,
          ),
          icon: Icon(
            Icons.edit,
            size: 20,
            color: Colors.grey.shade600,
          ),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}