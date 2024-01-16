import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_table_app/data/timetable_data_source.dart';
import 'package:time_table_app/domain/timetable.dart';

final timeTableProvider = ChangeNotifierProvider((ref) => TimeTableProvider());

class TimeTableProvider extends ChangeNotifier {
  List<TimeTable> _timeTableList = [];

  List<TimeTable> get timeTable => _timeTableList;

  Future<void> getAllTimeTable() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      final list = await DataSource.getAllTimeTable();
      _timeTableList = [...list];
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> createNewTimeTable(
      {required Map<String, String> timeTable}) async {
    try {
      _timeTableList.add(await DataSource.insertTimeTable(timeTable));

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateTimetable({required Map<String, String> timeTable}) async {
    try {
      final TimeTable update = await DataSource.updateTimeTable(timeTable);
      _timeTableList.where();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
