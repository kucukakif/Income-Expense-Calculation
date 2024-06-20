import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class MonthDB {
  static const dbName = "monthdatabase.db";
  static const dbVersion = 1;
  static const dbTable = "monthsTable";
  static const columnId = "id";
  static const columnName = "month";
  static const columnPrice = "price";

  static final MonthDB instance = MonthDB();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await sql.openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    db.execute('''
       CREATE TABLE $dbTable(
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnPrice INTEGER NOT NULL
       )
      ''');
  }

  insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(dbTable, row);
  }

  Future<List<Map<String, dynamic>>> queryDatabase() async {
    Database db = await instance.database;
    return await db.query(dbTable);
  }
}
