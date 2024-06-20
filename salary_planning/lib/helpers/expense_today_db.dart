import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:salary_planning/models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ExpenseTodayDB {
  static const dbName = "expensedatabase.db";
  static const dbVersion = 1;
  static const dbTable = "expenseTable";
  static const columnId = "id";
  static const columnExpense = "expense";
  static const columnAmount = "amount";
  static const columnCategoriName = "categoriName";
  static const columnExplanation = "explanation";
  static const columnDate = "date";
  static const columnyearDate = "yearDate";
  static const columnMonthDate = "monthDate";
  static const columnDayDate = "dayDate";
  static const columnNowDate = "nowDate";

  static final ExpenseTodayDB instance = ExpenseTodayDB();

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
        expense INTEGER NOT NULL,
        amount INTEGER,
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

  Future<List<ExpenseModel>> queryDatabase() async {
    Database db = await instance.database;
    var result = await db.query(dbTable);
    // String today = DateFormat.MMMMd().format(DateTime.now());
    return result.map((item) => ExpenseModel.fromMap(item)).toList();
  }

  Future<int> getExpenseTotal() async {
    var mapList = await queryDatabase();
    List<int> spendList = [];
    for (var element in mapList) {
      spendList.add(element.spend);
    }
    int total = spendList.fold(spendList.length, (i, j) => i + j);
    return total - spendList.length;
  }

  Future<int> todayExpenseTotal() async {
    var mapList = await queryDatabase();
    List<int> spendList = [];
    String dayDate = DateFormat.MMMMd().format(DateTime.now());
    for (int i = 0; i < mapList.length; i++) {
      if (mapList[i].dayDate == dayDate) {
        spendList.add(mapList[i].spend);
      }
    }
    int total = spendList.fold(spendList.length, (i, j) => i + j);
    return total - spendList.length;
  }

  Future<int> updateData(ExpenseModel expense) async {
    Database db = await instance.database;
    var res = await db.rawUpdate(
        'UPDATE  $dbTable SET expense = \'${expense.spend}\', amount = \'${expense.amount}\', date = \'${expense.date}\', yearDate = \'${expense.yearDate}\', monthDate = \'${expense.monthDate}\', dayDate = \'${expense.dayDate}\', categoriName = \'${expense.categoriName}\', explanation = \'${expense.explanation}\' WHERE id = ${expense.id}');
    return res;
  }

  Future<ExpenseModel> findItem(int id) async {
    var mapList = await queryDatabase();
    late ExpenseModel expenseModel;
    for (var element in mapList) {
      if (element.id == id) {
        expenseModel = element;
        break;
      }
    }
    return expenseModel;
  }

  Future<void> deleteData(int id) async {
    Database db = await instance.database;
    await db.delete(dbTable, where: 'id = ?', whereArgs: [id]);
  }
}
