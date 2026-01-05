import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/haptic_helper.dart';

/// Widget de opção de resposta
class AnswerOption extends StatefulWidget {
  final int answer;
  final VoidCallback onTap;
  final bool isDisabled;
  final int index;

  const AnswerOption({
    super.key,
    required this.answer,
    required this.onTap,
    this.isDisabled = false,
    required this.index,
  });

  @override
  State<AnswerOption> createState() => _AnswerOptionState();
}

class _AnswerOptionState extends State<AnswerOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled) {
      _controller.forward();
      HapticHelper.selection();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Gradientes diferentes para cada opção
    final gradients = [
      AppColors.primaryGradient,
      AppColors.accentGradient,
      AppColors.successGradient,
      LinearGradient(
        colors: [Color(0xFFFF6B9D), Color(0xFFC06C84)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isDisabled ? null : widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.isDisabled
                ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                : gradients[widget.index % gradients.length],
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.isDisabled
                    ? Colors.grey.withOpacity(0.3)
                    : gradients[widget.index % gradients.length]
                        .colors
                        .first
                        .withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${widget.answer}',
              style: AppTextStyles.numberMedium.copyWith(
                color: Colors.white,
                fontSize: 42,
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (widget.index * 100).ms)
        .slideY(begin: 0.3, end: 0);
  }
}
