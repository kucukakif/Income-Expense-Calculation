import 'package:salary_planning/models/income.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class IncomeDB {
  static const dbName = "incomedatabase.db";
  static const dbVersion = 1;
  static const dbTable = "incomeTable";
  static const columnId = "id";
  static const columnIncome = "income";
  static const columnCategoriName = "categoriName";
  static const columnExplanation = "explanation";
  static const columnDate = "date";
  static const columnYearDate = "yearDate";
  static const columnMonthDate = "monthDate";
  static const columnDayDate = "dayDate";
  static const columnNowDate = "nowDate";

  static final IncomeDB instance = IncomeDB();

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
    db.execute('''
CREATE TABLE $dbTable(
  id INTEGER PRIMARY KEY,
  income INTEGER NOT NULL,
  date TEXT NOT NULL,
  yearDate TEXT NOT NULL,
  monthDate TEXT NOT NULL,
  dayDate TEXT NOT NULL,
  categoriName TEXT NOT NULL,
  explanation TEXT,
  nowDate TEXT NOT NULL
)
      ''');
    print("Created tables");
  }

  insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(dbTable, row);
  }

  Future<List<IncomeModel>> queryDatabase() async {
    Database db = await instance.database;
    var result = await db.query(dbTable);
    return result.map((data) => IncomeModel.fromMap(data)).toList();
  }

  Future<void> deleteIncome(int id) async {
    Database db = await instance.database;
    await db.delete(dbTable, where: 'id  = ?', whereArgs: [id]);
  }

  Future<int> getIncomeTotal() async {
    var mapList = await queryDatabase();
    List<int> incomeList = [];
    for (var element in mapList) {
      incomeList.add(element.income!);
    }
    int total = incomeList.fold(incomeList.length, (i, j) => i + j);
    return total - incomeList.length;
  }
}
