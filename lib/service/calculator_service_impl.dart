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
    notifyListeners();
  }

  @override
  void deleteLast({int? cursorIndex}) {
    _hardwareService.vibrateClick();
    if (_expression.isEmpty) return;

    int target =
        (cursorIndex != null &&
            cursorIndex > 0 &&
            cursorIndex <= _expression.length)
        ? cursorIndex
        : _expression.length;

    if (target == 0) return;

    _expression =
        _expression.substring(0, target - 1) + _expression.substring(target);

    notifyListeners();
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
  void handleInput(String key, {int? cursorIndex}) {
    _hardwareService.vibrateClick();
    if (_isFinalized) {
      if (['+', '-', '×', '÷'].contains(key)) {
        _expression = _currentResult;
      } else {
        _expression = "";
      }
      _currentResult = "";
      _isFinalized = false;
    }

    int target =
        (cursorIndex != null &&
            cursorIndex >= 0 &&
            cursorIndex <= _expression.length)
        ? cursorIndex
        : _expression.length;

    _expression =
        _expression.substring(0, target) + key + _expression.substring(target);

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

  @override
  void loadHistory(String expression, String result) {
    _hardwareService.vibrateClick();
    _expression = expression;
    _currentResult = result;

    _isFinalized = true;
    notifyListeners();
  }

  @override
  void returnToEditMode() {
    if (_isFinalized) {
      _hardwareService.vibrateClick();
      _currentResult = "";
      _isFinalized = false;
      notifyListeners();
    }
  }
}
