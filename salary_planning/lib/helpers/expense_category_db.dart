import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/expense_category_model.dart';

class ExpenseCategoryDB {
  static const dbName = "expense_categorydatabase.db";
  static const dbVersion = 1;
  static const dbTable = "expense_categoryTable";
  static const columnId = "id";
  static const columnCategoryName = "categoryName";
  static const columnValue = "value";

  static final ExpenseCategoryDB instance = ExpenseCategoryDB();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, dbName);
    return await sql.openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''
       CREATE TABLE $dbTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        categoryName TEXT NOT NULL,
        value TEXT
       )
''');
    print('Created tables');
  }

  insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(dbTable, row);
  }

  Future<List<ExpenseCategoryModel>> queryDatabase() async {
    Database db = await instance.database;
    var result = await db.query(dbTable);
    return result.map((e) => ExpenseCategoryModel.fromMap(e)).toList();
  }

  Future<int> updateData(
    String categoriName,
    String value,
    int id,
  ) async {
    Database db = await instance.database;
    var res = await db.rawUpdate('''
    UPDATE $dbTable
    SET categoryName = ?, value = ?
    WHERE id = ?
    ''', [categoriName, value, id]);
    return res;
  }

  Future<void> deleteData(String categoryName) async {
    Database db = await instance.database;
    await db.delete(dbTable, where: 'categoryName = ?', whereArgs: [categoryName]);
  }
}
