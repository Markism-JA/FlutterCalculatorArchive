import 'package:math_keyboard/math_keyboard.dart';

abstract interface class CalculatorService {
  /// The controller that drives the MathField UI.
  MathFieldEditingController get controller;

  /// Stream or Getter to notify the UI if we are in a 'Finalized' (result shown) state.
  bool get isFinalized;

  /// The current calculated result string.
  String get currentResult;

  /// Logic for when the '=' or 'Enter' key is pressed.
  void compute();

  /// Logic for 'AC' - wipes the tree and the result.
  void clearAll();

  /// Logic for '+/-' - negates the current expression.
  void toggleSign();

  /// Programmatic input (Used by custom buttons or desktop hardware).
  void handleInput(String key);
}
