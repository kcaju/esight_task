import 'package:flutter/material.dart';

class GetStartedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final ValueChanged<bool>? onHoverOrPress;
  final bool isActive;
  final bool isPressed;

  const GetStartedButton({
    super.key,
    this.onPressed,
    this.onHoverOrPress,
    this.isActive = true,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: AnimatedScale(
        scale: isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isActive ? onPressed : null,
            onTapDown: isActive && onHoverOrPress != null
                ? (_) => onHoverOrPress!(true)
                : null,
            onTapUp: isActive && onHoverOrPress != null
                ? (_) => onHoverOrPress!(false)
                : null,
            onTapCancel: isActive && onHoverOrPress != null
                ? () => onHoverOrPress!(false)
                : null,
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFF1E1E1E).withValues(alpha: 0.22),
                  width: isActive ? 2.0 : 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFF1E1E1E).withValues(alpha: 0.35),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                    child: const Text('Get Started'),
                  ),
                  const Spacer(),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isActive ? 1.0 : 0.35,
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF1E1E1E),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
