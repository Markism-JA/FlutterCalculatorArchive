import 'dart:async';
import 'package:advmobprog_prefinals_tp01_amarille/model/history_entry.dart';
import 'package:advmobprog_prefinals_tp01_amarille/service/history_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HistoryService)
class HistoryServiceImpl implements HistoryService {
  final List<HistoryEntry> _historyList = [];

  final StreamController<List<HistoryEntry>> _controller =
      StreamController<List<HistoryEntry>>.broadcast();

  @override
  Stream<List<HistoryEntry>> get historyStream => _controller.stream;

  @override
  Future<void> save(String expression, String result) async {
    final entry = HistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );

    _historyList.insert(0, entry);

    _controller.add(List.unmodifiable(_historyList));
  }

  @override
  Future<void> delete(String id) async {
    _historyList.removeWhere((entry) => entry.id == id);
    _controller.add(List.unmodifiable(_historyList));
  }

  @override
  Future<void> clear() async {
    _historyList.clear();
    _controller.add(List.unmodifiable(_historyList));
  }

  @disposeMethod
  void dispose() {
    _controller.close();
  }
}
