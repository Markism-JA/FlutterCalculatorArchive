import 'package:advmobprog_prefinals_tp01_amarille/service/calculator_service.dart';
import 'package:advmobprog_prefinals_tp01_amarille/service/history_service.dart';
import 'package:advmobprog_prefinals_tp01_amarille/service/platform_hardware_service.dart';
import 'package:advmobprog_prefinals_tp01_amarille/service/math_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CalculatorService)
class CalculatorServiceImpl extends ChangeNotifier
    implements CalculatorService {
  final MathEngine _mathEngine;
  final HistoryService _historyService;
  final PlatformHardwareService _hardwareService;

  String _expression = "";
  String _currentResult = "";
  bool _isFinalized = false;

  CalculatorServiceImpl(
    this._mathEngine,
    this._historyService,
    this._hardwareService,
  );

  @override
  String get expression => _expression;

  @override
  String get currentResult => _currentResult;

  @override
  bool get isFinalized => _isFinalized;

  @override
  void clearAll() {
    _expression = "";
    _currentResult = "";
    _isFinalized = false;
    _hardwareService.vibrateClick();
    notifyListeners(); // Tell UI to update
  }

  @override
  void deleteLast() {
    _hardwareService.vibrateClick();

    if (_isFinalized) {
      clearAll();
      return;
    }

    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
    }
  }

  @override
  void compute() {
    if (_expression.isEmpty) return;

    try {
      final double val = _mathEngine.evaluate(_expression);

      _currentResult = _mathEngine.formatResult(val);
      _isFinalized = true;

      _historyService.save(_expression, _currentResult);

      _hardwareService.vibrateClick();
    } catch (e) {
      _currentResult = "Error";
      _hardwareService.vibrateError();
    }
    notifyListeners();
  }

  @override
  void handleInput(String key) {
    _hardwareService.vibrateClick();

    if (_isFinalized) {
      if (_isOperator(key) && _currentResult != "Error") {
        _expression = _currentResult + key;
      } else {
        _expression = key;
      }
      _currentResult = "";
      _isFinalized = false;
      notifyListeners();
      return;
    }

    _expression += key;
    notifyListeners();
  }

  @override
  void toggleSign() {
    _hardwareService.vibrateClick();

    if (_expression.isEmpty) return;

    if (_isFinalized && _currentResult != "Error") {
      if (_currentResult.startsWith("-")) {
        _expression = _currentResult.substring(1);
      } else {
        _expression = "-$_currentResult";
      }
      _currentResult = "";
      _isFinalized = false;
      notifyListeners();
      return;
    }

    if (_expression.startsWith("-(") && _expression.endsWith(")")) {
      _expression = _expression.substring(2, _expression.length - 1);
    } else {
      _expression = "-($_expression)";
    }
    notifyListeners();
  }

  bool _isOperator(String key) {
    return key == '+' ||
        key == '-' ||
        key == '*' ||
        key == '/' ||
        key == '×' ||
        key == '÷';
  }
}
