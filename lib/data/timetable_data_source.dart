import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_table_app/domain/timetable.dart';

class DataSource {
  static const int _version = 1;
  static const String _dbName = "Timetable";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute("""
  CREATE TABLE
  Timetable(
    id INTEGER PRIMARY KEY,
    subject TEXT NOT NULL ,
    day TEXT NOT NULL,
    time TEXT NOT NULL 
  );
          """),
      version: _version,
    );
  }

  static Future<List<TimeTable>> getAllTimeTable() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> dbMap = await db.query(_dbName);
    print('Map: $dbMap');
    return List.generate(
      dbMap.length,
      (index) => TimeTable.fromMap(
        dbMap[index],
      ),
    );
  }

  static Future<TimeTable> insertTimeTable(
      Map<String, String> timeTableModel) async {
    final db = await _getDB();
    final id = await db.insert(_dbName, timeTableModel,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return TimeTable(
        id: id,
        subject: timeTableModel['subject'] ?? "",
        day: timeTableModel['day'] ?? "",
        time: timeTableModel['time'] ?? "");
  }

  static Future<TimeTable> updateTimeTable(
      Map<String, String> timeTableModel) async {
    final db = await _getDB();
    final id = await db.update(_dbName, timeTableModel,
        where: 'id = ?', whereArgs: [timeTableModel['id']]);
    return TimeTable(
        id: id,
        subject: timeTableModel['subject'] ?? "",
        day: timeTableModel['day'] ?? "",
        time: timeTableModel['time'] ?? "");
  }
}
