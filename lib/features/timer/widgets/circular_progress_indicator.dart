
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/app_color_scheme.dart';

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final progress = target.inMilliseconds > 0
        ? (elapsed.inMilliseconds / target.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    final percentage = (progress * 100).round();
    final isOvertime = elapsed > target;

    // Use theme-aware colors
    final backgroundColor = AppColors.getCardBorder(isDarkMode);
    final progressColor = isOvertime
        ? AppColors.danger
        : AppColors.getProgressColor(progress);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle with subtle gradient
          CustomPaint(
            size: Size(size, size),
            painter: _CircleProgressPainter(
              progress: progress,
              strokeWidth: 8,
              backgroundColor: backgroundColor,
              progressColor: progressColor,
              isDarkMode: isDarkMode,
              isOvertime: isOvertime,
            ),
          ),

          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Percentage or overtime indicator
              Text(
                isOvertime ? 'OVERTIME' : '$percentage%',
                style: TextStyle(
                  fontSize: isOvertime ? size * 0.08 : size * 0.15,
                  fontWeight: FontWeight.bold,
                  color: isOvertime
                      ? AppColors.danger
                      : AppColors.getTextPrimary(isDarkMode),
                ),
              ),

              if (!isOvertime) ...[
                const SizedBox(height: 4),
                Text(
                  'complete',
                  style: TextStyle(
                    fontSize: size * 0.08,
                    color: AppColors.getTextSecondary(isDarkMode),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              // Show elapsed time if overtime
              if (isOvertime) ...[
                const SizedBox(height: 4),
                Text(
                  _formatDuration(elapsed),
                  style: TextStyle(
                    fontSize: size * 0.06,
                    color: AppColors.danger.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ],
          ),

          // Subtle inner shadow effect for depth
          if (!isDarkMode)
            CustomPaint(
              size: Size(size, size),
              painter: _InnerShadowPainter(
                strokeWidth: 8,
                shadowColor: Colors.black.withOpacity(0.05),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final bool isDarkMode;
  final bool isOvertime;

  _CircleProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
    required this.isDarkMode,
    required this.isOvertime,
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
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // Start at the top

    if (isOvertime) {
      // For overtime, create a pulsing effect with gradient
      final shader = LinearGradient(
        colors: [
          progressColor,
          progressColor.withOpacity(0.6),
          progressColor,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

      progressPaint.shader = shader;

      // Draw full circle for overtime
      canvas.drawCircle(center, radius, progressPaint);
    } else {
      // Normal progress with gradient
      final shader = LinearGradient(
        colors: [
          progressColor,
          progressColor.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

      progressPaint.shader = shader;

      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _CircleProgressPainter &&
        (oldDelegate.progress != progress ||
            oldDelegate.strokeWidth != strokeWidth ||
            oldDelegate.backgroundColor != backgroundColor ||
            oldDelegate.progressColor != progressColor ||
            oldDelegate.isDarkMode != isDarkMode ||
            oldDelegate.isOvertime != isOvertime);
  }
}

class _InnerShadowPainter extends CustomPainter {
  final double strokeWidth;
  final Color shadowColor;

  _InnerShadowPainter({
    required this.strokeWidth,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final shadowPaint = Paint()
      ..color = shadowColor
      ..strokeWidth = strokeWidth * 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth * 0.25, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}