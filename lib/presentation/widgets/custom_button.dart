import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/haptic_helper.dart';

/// Botão customizado com gradiente e animações
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient gradient;
  final IconData? icon;
  final bool isSecondary;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient = AppColors.primaryGradient,
    this.icon,
    this.isSecondary = false,
    this.isDisabled = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isDisabled ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: widget.isSecondary ? 60 : 70,
          decoration: BoxDecoration(
            gradient: widget.isDisabled
                ? const LinearGradient(
                    colors: [Colors.grey, Colors.grey],
                  )
                : widget.gradient,
            borderRadius: BorderRadius.circular(widget.isSecondary ? 16 : 20),
            // Efeito 3D - borda inferior mais escura
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withOpacity(0.3),
                width: widget.isSecondary ? 3 : 4,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isDisabled
                    ? Colors.grey.withOpacity(0.3)
                    : (widget.gradient.colors.first).withOpacity(0.4),
                blurRadius: widget.isSecondary ? 12 : 20,
                offset: Offset(0, widget.isSecondary ? 4 : 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: Colors.white,
                    size: widget.isSecondary ? 22 : 28,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    widget.text,
                    style: widget.isSecondary
                        ? AppTextStyles.button.copyWith(color: Colors.white)
                        : AppTextStyles.buttonLarge.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
