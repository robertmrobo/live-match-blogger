import 'package:flutter/material.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import '../utils/timer_calculations.dart';
import '../utils/timer_colors.dart';

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

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isOvertime ? Icons.timer_off : Icons.timer,
                  size: 20,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  isOvertime ? 'Overtime' : 'Remaining',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              remaining.toMMSS(),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: TimerColors.getRemainingColor(elapsed, target),
              ),
            ),
            if (isOvertime) ...[
              const SizedBox(height: 8),
              Text(
                'You\'ve exceeded your target time',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}