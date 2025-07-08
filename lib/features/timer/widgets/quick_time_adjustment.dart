import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/timer_notifier.dart';
import '../providers/target_time_notifier.dart';

enum AdjustmentMode { timer, target }

class QuickTimeAdjustment extends ConsumerStatefulWidget {
  final VoidCallback? onClose;

  const QuickTimeAdjustment({super.key, this.onClose});

  @override
  ConsumerState<QuickTimeAdjustment> createState() => _QuickTimeAdjustmentState();
}

class _QuickTimeAdjustmentState extends ConsumerState<QuickTimeAdjustment>
    with SingleTickerProviderStateMixin {
  AdjustmentMode _mode = AdjustmentMode.timer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quick Adjustments',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onClose,
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Mode Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildModeButton('Timer', AdjustmentMode.timer),
                        _buildModeButton('Target', AdjustmentMode.target),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Adjustment Buttons
                  if (_mode == AdjustmentMode.timer) _buildTimerButtons(),
                  if (_mode == AdjustmentMode.target) _buildTargetButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeButton(String label, AdjustmentMode mode) {
    final isSelected = _mode == mode;
    return GestureDetector(
      onTap: () => setState(() => _mode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTimerButtons() {
    final timerNotifier = ref.read(timerProvider.notifier);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAdjustmentButton(
              '-5 min',
                  () => timerNotifier.subtractTime(const Duration(minutes: 5)),
              Colors.red.shade400,
            ),
            const SizedBox(width: 8),
            _buildAdjustmentButton(
              '-1 min',
                  () => timerNotifier.subtractTime(const Duration(minutes: 1)),
              Colors.red.shade300,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAdjustmentButton(
              '+1 min',
                  () => timerNotifier.addTime(const Duration(minutes: 1)),
              Colors.green.shade400,
            ),
            const SizedBox(width: 8),
            _buildAdjustmentButton(
              '+5 min',
                  () => timerNotifier.addTime(const Duration(minutes: 5)),
              Colors.green.shade500,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTargetButtons() {
    final targetNotifier = ref.read(targetTimeProvider.notifier);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAdjustmentButton(
              '-30 min',
                  () => targetNotifier.subtractTime(const Duration(minutes: 30)),
              Colors.red.shade400,
            ),
            const SizedBox(width: 8),
            _buildAdjustmentButton(
              '-15 min',
                  () => targetNotifier.subtractTime(const Duration(minutes: 15)),
              Colors.red.shade300,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAdjustmentButton(
              '+15 min',
                  () => targetNotifier.addTime(const Duration(minutes: 15)),
              Colors.green.shade400,
            ),
            const SizedBox(width: 8),
            _buildAdjustmentButton(
              '+30 min',
                  () => targetNotifier.addTime(const Duration(minutes: 30)),
              Colors.green.shade500,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdjustmentButton(String label, VoidCallback onTap, Color color) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}