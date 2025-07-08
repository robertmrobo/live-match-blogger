import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularProgressIndicator extends StatelessWidget {
  final Duration elapsed;
  final Duration target;
  final double size;

  const CircularProgressIndicator({
    super.key,
    required this.elapsed,
    required this.target,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target.inMilliseconds > 0
        ? (elapsed.inMilliseconds / target.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    final percentage = (progress * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: _CircleProgressPainter(
              progress: progress,
              strokeWidth: 8,
              backgroundColor: Colors.grey.shade200,
              progressColor: _getProgressColor(progress),
            ),
          ),
          // Center text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                'complete',
                style: TextStyle(
                  fontSize: size * 0.08,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) {
      return Colors.green;
    } else if (progress >= 0.75) {
      return Colors.blue;
    } else if (progress >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _CircleProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // Start at the top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _CircleProgressPainter &&
        (oldDelegate.progress != progress ||
            oldDelegate.strokeWidth != strokeWidth ||
            oldDelegate.backgroundColor != backgroundColor ||
            oldDelegate.progressColor != progressColor);
  }
}