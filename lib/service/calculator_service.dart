abstract interface class CalculatorService {
  String get expression;

  String get currentResult;

  bool get isFinalized;

  void handleInput(String key);

  void compute();

  void clearAll();

  void deleteLast();

  void toggleSign();
}
