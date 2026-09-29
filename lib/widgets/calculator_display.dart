import 'dart:math' as math;
import 'package:flutter/material.dart';

class CalculatorDisplay extends StatefulWidget {
  final String expression;
  final String result;
  final VoidCallback? onTapToEdit;
  final ValueNotifier<int>? cursorNotifier;
  final FocusNode textFieldFocusNode;

  const CalculatorDisplay({
    super.key,
    required this.expression,
    required this.result,
    required this.textFieldFocusNode,
    this.onTapToEdit,
    this.cursorNotifier,
  });

  @override
  State<CalculatorDisplay> createState() => _CalculatorDisplayState();
}

class _CalculatorDisplayState extends State<CalculatorDisplay> {
  late _ExpressionController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = _ExpressionController();
    _controller.text = widget.expression;

    _controller.addListener(() {
      if (_controller.selection.isValid && widget.cursorNotifier != null) {
        widget.cursorNotifier!.value = _controller.selection.baseOffset;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final colorScheme = Theme.of(context).colorScheme;
    _controller.operatorColor = colorScheme.primary;
    _controller.defaultColor = colorScheme.onSurfaceVariant;
  }

  @override
  void didUpdateWidget(CalculatorDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool expressionChanged = widget.expression != oldWidget.expression;
    bool returnedToEdit = oldWidget.result.isNotEmpty && widget.result.isEmpty;

    if (expressionChanged || returnedToEdit) {
      final oldText = oldWidget.expression;
      final newText = widget.expression;
      final previousSelection = _controller.selection;

      int newOffset;

      if (returnedToEdit) {
        newOffset = newText.length;
      } else if (previousSelection.isValid) {
        if (previousSelection.baseOffset == oldText.length) {
          newOffset = newText.length;
        } else {
          int lengthDiff = newText.length - oldText.length;
          newOffset = previousSelection.baseOffset + lengthDiff;
        }
      } else {
        newOffset = newText.length;
      }

      newOffset = math.max(0, math.min(newOffset, newText.length));

      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newOffset),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  double _getDynamicFontSize(String text, {double max = 72, double min = 32}) {
    if (text.length <= 8) return max;
    double size = max - ((text.length - 8) * 3);
    return size < min ? min : size;
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEvaluated = widget.result.isNotEmpty;

    return GestureDetector(
      onTap: isEvaluated ? widget.onTapToEdit : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: isEvaluated ? 40 : 0,
              alignment: Alignment.bottomRight,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isEvaluated ? 1.0 : 0.0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    widget.expression,
                    style: TextStyle(
                      fontSize: 24,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: isEvaluated
                  ? _buildResultText(colorScheme)
                  : _buildActiveExpression(colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveExpression(ColorScheme colorScheme) {
    final fontSize = _getDynamicFontSize(widget.expression, max: 64, min: 32);

    return TextField(
      key: const ValueKey('expression_input'),
      focusNode: widget.textFieldFocusNode,
      controller: _controller,
      scrollController: _scrollController,
      readOnly: true,
      showCursor: true,
      autofocus: true,
      enableInteractiveSelection: true,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.0,
        color: colorScheme.onSurfaceVariant,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildResultText(ColorScheme colorScheme) {
    final formattedResult = _formatWithCommas(widget.result);
    final fontSize = _getDynamicFontSize(formattedResult, max: 72, min: 36);

    return SizedBox(
      key: const ValueKey('result_display'),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Text(
          formattedResult,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -1.5,
          ),
        ),
      ),
    );
  }
}

class _ExpressionController extends TextEditingController {
  Color operatorColor = Colors.blue;
  Color defaultColor = Colors.black;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    List<TextSpan> spans = [];
    final operatorRegex = RegExp(r'([+\-×÷*/])');
    final matches = operatorRegex.allMatches(text);

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style?.copyWith(color: defaultColor),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(0),
          style: style?.copyWith(color: operatorColor),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: style?.copyWith(color: defaultColor),
        ),
      );
    }

    return TextSpan(style: style, children: spans);
  }
}
