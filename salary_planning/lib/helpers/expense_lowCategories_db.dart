import 'package:path/path.dart';
import 'package:salary_planning/models/expense_low_categoriy_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ExpenseLowCategoriesDB {
  static const dbName = "expenseLowCategoriesdatabase.db";
  static const dbVersion = 1;
  static const dbTable = "expenseLowCategoriesTable";
  static const columnId = "id";
  static const columnCategoryname = "categoryName";
  static const columnLowCategoryName = "lowCategoryName";

  static final ExpenseLowCategoriesDB instance = ExpenseLowCategoriesDB();

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
  lowCategoryName TEXT
    )
      ''');
    print("Created tables");
  }

  insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(dbTable, row);
  }

  Future<List<ExpenseLowCategoriyModel>> queryDatabase() async {
    Database db = await instance.database;
    var result = await db.query(dbTable);
    return result
        .map((item) => ExpenseLowCategoriyModel.fromMap(item))
        .toList();
  }

  Future<void> deleteData(int id) async {
    Database db = await instance.database;
    await db.delete(dbTable, where: 'id = ?', whereArgs: [id]);
  }
}
