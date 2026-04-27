class HistoryEntry {
  final String id;
  final String expression;
  final String result;
  final DateTime timestamp;

  HistoryEntry({
    required this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });
}
