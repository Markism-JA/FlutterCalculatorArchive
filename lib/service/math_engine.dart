import 'package:math_expressions/math_expressions.dart';

abstract interface class MathEngine {
  double evaluateExpression(String expression);

  double evaluateString(String input);

  String formatResult(double value);

  Expression simplify(Expression expression);
}
