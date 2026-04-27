import 'dart:async';
import 'dart:convert';
import 'package:advmobprog_prefinals_tp01_amarille/model/history_entry.dart';
import 'package:advmobprog_prefinals_tp01_amarille/service/history_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

@LazySingleton(as: HistoryService)
class HistoryServiceImpl implements HistoryService {
  final List<HistoryEntry> _historyList = [];
  final StreamController<List<HistoryEntry>> _controller =
      StreamController<List<HistoryEntry>>.broadcast();

  static const String _storageKey = 'calculator_history_data';

  var logger = Logger();

  HistoryServiceImpl() {
    _loadFromDisk();
  }

  @override
  Stream<List<HistoryEntry>> get historyStream => _controller.stream;

  @override
  List<HistoryEntry> get history => List.unmodifiable(_historyList);

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

    await _saveToDisk();
  }

  @override
  Future<void> delete(String id) async {
    _historyList.removeWhere((entry) => entry.id == id);
    _controller.add(List.unmodifiable(_historyList));

    await _saveToDisk();
  }

  @override
  Future<void> clear() async {
    _historyList.clear();
    _controller.add(List.unmodifiable(_historyList));

    await _saveToDisk();
  }

  @override
  void dispose() {
    _controller.close();
  }

  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String encodedData = jsonEncode(
        _historyList
            .map(
              (e) => {
                'id': e.id,
                'expression': e.expression,
                'result': e.result,
                'timestamp': e.timestamp.toIso8601String(),
              },
            )
            .toList(),
      );

      await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      logger.e("Failed to save history to disk: $e");
    }
  }

  Future<void> _loadFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString(_storageKey);

      if (encodedData != null) {
        final List<dynamic> decodedList = jsonDecode(encodedData);

        _historyList.clear();
        for (var item in decodedList) {
          _historyList.add(
            HistoryEntry(
              id: item['id'],
              expression: item['expression'],
              result: item['result'],
              timestamp: DateTime.parse(item['timestamp']),
            ),
          );
        }
        _controller.add(List.unmodifiable(_historyList));
      }
    } catch (e) {
      logger.e("Failed to save history to disk: $e");
    }
  }
}
