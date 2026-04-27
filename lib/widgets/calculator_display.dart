import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String expression;
  final String result;

  const CalculatorDisplay({
    super.key,
    required this.expression,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildExpressionText(context, theme, colorScheme),

          const SizedBox(height: 8),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _formatWithCommas(result),
              style: textTheme.displayLarge?.copyWith(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpressionText(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (expression.isEmpty) return const SizedBox(height: 32);

    final baseNumberStyle = theme.textTheme.headlineMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
    );

    final operatorStyle = baseNumberStyle?.copyWith(color: colorScheme.primary);

    List<TextSpan> spans = [];
    final operatorRegex = RegExp(r'([+\-×÷*/])');
    final matches = operatorRegex.allMatches(expression);

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: expression.substring(lastMatchEnd, match.start),
            style: baseNumberStyle,
          ),
        );
      }

      spans.add(TextSpan(text: ' ${match.group(0)} ', style: operatorStyle));

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < expression.length) {
      spans.add(
        TextSpan(
          text: expression.substring(lastMatchEnd),
          style: baseNumberStyle,
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }

  String _formatWithCommas(String text) {
    if (text.isEmpty || text == "Error" || text == "Infinity") return text;

    try {
      List<String> parts = text.split('.');
      RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      parts[0] = parts[0].replaceAllMapped(
        reg,
        (Match match) => '${match[1]},',
      );
      return parts.join('.');
    } catch (e) {
      return text;
    }
  }
}
