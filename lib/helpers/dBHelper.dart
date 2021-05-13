import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'rangeModel.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String rangeTable = 'range_table';
  String colId = 'id';
  String colDate = 'date';
  String colMobile = 'mobile';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'Ranges.db';

    var rangeDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return rangeDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $rangeTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDate TEXT, $colMobile  TEXT UNIQUE)');
  }

  Future<List<Map<String, dynamic>>> getRangesMapList() async {
    Database db = await this.database;
    var result = await db.query(rangeTable, orderBy: '$colDate ASC');
    return result;
  }

  // Insert a Range object to database
  Future<int> insertRange(Range range) async {
    Database db = await this.database;

    var result = await db.insert(rangeTable, range.toMap());
    return result;
  }

  Future<int> deleteRange(String mobile) async {
    var db = await this.database;
    int result = await db
        .rawDelete('DELETE FROM $rangeTable WHERE $colMobile = $mobile');
    print("Delete result $result");
    return result;
  }

  Future<bool> getRangeExists(String number) async {
    print(number);
    Database db = await this.database;

    var res = await db.rawQuery('SELECT $colMobile FROM $rangeTable ');
    bool ans = false;
    for (var element in res) {
      ans = element.containsValue(number) ? true : false;
      if (ans) break;
    }

    print(ans);
    return ans;
  }

  Future<int> getTodayCounts() async {
    Database db = await this.database;
    String date = (DateTime.now().toString().split(' ')[0]);
    var res =
        await db.query(rangeTable, where: '$colDate = ?', whereArgs: [date]);
    //  var res =
    //     await db.rawQuery('SELECT * FROM $rangeTable WHERE $colDate = $date');
    print(res);
    print(res.length);
    return res.length;
  }

  Future getRangeDate(mobile) async {
    Database db = await this.database;

    var res = await db.rawQuery(
        'SELECT $colDate FROM $rangeTable WHERE  $colMobile = $mobile');
    //print(res);
    return (res[0]['date']);
  }

  Future insertBasedOnCondition(mobile) async {
    bool res = await getRangeExists(mobile);
    var date = (DateTime.now().toString().split(' ')[0]);
    //res true delete and insert. res false insert
    if (res) {
      await deleteRange(mobile);
      Range range = Range(mobile, date);
      await insertRange(range);
      print('deleted and inserted');
    } else {
      Range range = Range(mobile, date);
      await insertRange(range);
      print('inserted');
    }
  }
}
