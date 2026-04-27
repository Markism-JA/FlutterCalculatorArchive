import 'package:advmobprog_prefinals_tp01_amarille/service/math_engine.dart';
import 'package:injectable/injectable.dart';
import 'package:math_expressions/math_expressions.dart';

@LazySingleton(as: MathEngine)
class MathEngineImpl implements MathEngine {
  @override
  double evaluate(String expression) {
    String cleanExpression = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/');

    final ShuntingYardParser parser = ShuntingYardParser();
    final Expression exp = parser.parse(cleanExpression);

    final ContextModel contextModel = ContextModel();
    // ignore: deprecated_member_use
    final double result = exp.evaluate(EvaluationType.REAL, contextModel);

    return result;
  }

  @override
  String formatResult(double value) {
    if (value.isNaN) return "Error";

    if (value.isInfinite) {
      return value.isNegative ? "-Infinity" : "Infinity";
    }

    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    String result = value.toString();

    if (result.length > 12) {
      if (value.abs() > 999999999 || value.abs() < 0.0000001) {
        return value.toStringAsExponential(5);
      } else {
        return value
            .toStringAsFixed(8)
            .replaceAll(RegExp(r'0*$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
    }

    return result;
  }
}
