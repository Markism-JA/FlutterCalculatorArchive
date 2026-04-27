import 'package:advmobprog_prefinals_tp01_amarille/model/history_entry.dart';

abstract interface class HistoryService {
  Stream<List<HistoryEntry>> get historyStream;

  Future<void> save(String expression, String result);

  Future<void> delete(String id);

  Future<void> clear();

  void dispose();
}
