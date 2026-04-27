abstract interface class CalculatorService {
  String get expression;

  String get currentResult;

  bool get isFinalized;

  void handleInput(String key, {int? cursorIndex});

  void compute();

  void clearAll();

  void deleteLast({int? cursorIndex});

  void toggleSign();

  void loadHistory(String expression, String result);

  void returnToEditMode();
}
