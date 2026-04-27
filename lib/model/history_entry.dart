class HistoryEntry {
  final String id;
  final String texExpression;
  final String result;
  final DateTime timestamp;

  HistoryEntry({
    required this.id,
    required this.texExpression,
    required this.result,
    required this.timestamp,
  });
}
