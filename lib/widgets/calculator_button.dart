import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? backgroundColor;
  final int flex;

  const CalculatorButton({
    super.key,
    required this.child,
    required this.onTap,
    this.textColor,
    this.backgroundColor,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurfaceVariant;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(50),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: IconTheme(
                data: IconThemeData(color: effectiveTextColor, size: 28),
                child: DefaultTextStyle(
                  style: theme.textTheme.headlineMedium!.copyWith(
                    color: effectiveTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
