import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/income_category_model.dart';

class IncomeCategoryDB {
  static const dbName = "income_categorydatabase.db";
  static const dbVersion = 1;
  static const dbTable = "income_categoryTable";
  static const columnId = "id";
  static const columnCategoryName = "categoryName";

  static final IncomeCategoryDB instance = IncomeCategoryDB();
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
        categoryName TEXT NOT NULL
       )
''');
    print('Created tables');
  }

  insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(dbTable, row);
  }

  Future<List<IncomeCategoryModel>> queryDatabase() async {
    Database db = await instance.database;
    var result = await db.query(dbTable);
    return result.map((e) => IncomeCategoryModel.fromMap(e)).toList();
  }

  Future<int> updateData(String categoriName, int id) async {
    Database db = await instance.database;
    var res = await db.rawUpdate(
        'UPDATE  $dbTable SET categoryName = \'$categoriName\' WHERE id = $id');
    return res;
  }

  Future<void> deleteData(String categoryName) async {
    Database db = await instance.database;
    await db.delete(dbTable, where: 'categoryName = ?', whereArgs: [categoryName]);
  }
}
