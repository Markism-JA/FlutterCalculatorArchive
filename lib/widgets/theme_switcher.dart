import 'package:flutter/material.dart';

class ThemeSwitcher extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const ThemeSwitcher({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
  });

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  static const double _width = 100.0;
  static const double _height = 48.0;
  static const double _margin = 4.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.isDarkMode);
      },
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: widget.isDarkMode
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(_margin),
                child: Container(
                  width: (_width / 2) - _margin,
                  height: _height - (_margin * 2),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIcon(
                  Icons.wb_sunny_outlined,
                  !widget.isDarkMode,
                  colorScheme,
                ),
                _buildIcon(
                  Icons.nightlight_round_outlined,
                  widget.isDarkMode,
                  colorScheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, bool isActive, ColorScheme colorScheme) {
    return Expanded(
      child: Icon(
        icon,
        size: 24,
        color: isActive
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
      ),
    );
  }
}
