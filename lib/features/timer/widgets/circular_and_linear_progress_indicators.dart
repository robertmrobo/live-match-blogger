import 'package:flutter/material.dart';
import 'package:live_match_blogger/features/extensions/duration_format.dart';
import 'dart:math' as math;

import '../models/timer_data.dart';
import '../models/timer_state.dart';
import '../utils/timer_calculations.dart';
import '../utils/timer_colors.dart';

class CircularProgressIndicator extends StatelessWidget {
  final TimerData timerData;
  final Duration targetTime;

  const CircularProgressIndicator({
    super.key,
    required this.timerData,
    required this.targetTime,
  });

  @override
  Widget build(BuildContext context) {
    final progress = TimerCalculations.calculateProgress(timerData.duration, targetTime);
    
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          // Background circle
          CustomPaint(
            size: const Size(200, 200),
            painter: _CircularProgressPainter(
              progress: 1.0,
              color: Colors.grey.shade300,
              strokeWidth: 8,
            ),
          ),
          // Progress circle
          AnimatedBuilder(
            animation: AlwaysStoppedAnimation(progress),
            builder: (context, child) {
              return CustomPaint(
                size: const Size(200, 200),
                painter: _CircularProgressPainter(
                  progress: progress,
                  color: TimerColors.getProgressColor(progress),
                  strokeWidth: 8,
                ),
              );
            },
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getStatusIcon(timerData.state),
                  size: 32,
                  color: TimerColors.getTimerColor(timerData.state),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TimerColors.getProgressColor(progress),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(TimerState state) {
    switch (state) {
      case TimerState.running:
        return Icons.play_arrow;
      case TimerState.paused:
        return Icons.pause;
      case TimerState.stopped:
        return Icons.stop;
    }
  }
}

class LinearProgressBar extends StatelessWidget {
  final TimerData timerData;
  final Duration targetTime;

  const LinearProgressBar({
    super.key,
    required this.timerData,
    required this.targetTime,
  });

  @override
  Widget build(BuildContext context) {
    final progress = TimerCalculations.calculateProgress(timerData.duration, targetTime);
    
    return Container(
      width: 300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '00:00',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                targetTime.toMMSS(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                TimerColors.getProgressColor(progress),
              ),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: TextStyle(
              fontSize: 12,
              color: TimerColors.getProgressColor(progress),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
