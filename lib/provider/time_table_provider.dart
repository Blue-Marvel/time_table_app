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
      print(_timeTableList);
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

  Future<void> updateTimetable(
      {required Map<String, dynamic> timeTable}) async {
    try {
      final TimeTable update = await DataSource.updateTimeTable(timeTable);
      int indexToUpdate =
          _timeTableList.indexWhere((map) => map.id == update.id);
      print(indexToUpdate);
      if (indexToUpdate != -1) {
        _timeTableList[indexToUpdate] = update;
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTimetable(int id) async {
    _timeTableList.removeWhere((element) => element.id == id);
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    try {
      await DataSource.deleteTimeTable(id);
    } catch (e) {
      rethrow;
    }
  }
}
