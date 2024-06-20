import 'dart:ffi';

import 'package:path/path.dart';
import 'package:salary_planning/models/past_year_model.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class PastYearsDb {
  static const dbName = "pastyears.db";
  static const dbVersion = 1;
  static const dbTable = "pastYearsTable";
  static const columnId = "id";
  static const incomeList = "incomeList";
  static const expenseList = "expenseList";

  // static const columnExpense = "expense";
  // static const columnExpenseAmount = "ExpenseAmount";
  // static const columnExpenseCategoriName = "ExpenseCategoriName";
  // static const columnExpenseExplanation = "ExpenseExplanation";
  // static const columnExpenseDate = "ExpenseDate";
  // static const columnExpenseyearDate = "ExpenseYearDate";
  // static const columnExpenseMonthDate = "ExpenseMonthDate";
  // static const columnExpenseDayDate = "ExpenseDayDate";
  // static const columnExpenseNowDate = "ExpenseNowDate";

  // static const columnIncome = "income";
  // static const columnIncomeAmount = "incomeAmount";
  // static const columnIncomeCategoriName = "incomeCategoriName";
  // static const columnIncomeExplanation = "incomeExplanation";
  // static const columnIncomeDate = "incomeDate";
  // static const columnIncomeYearDate = "incomeYearDate";
  // static const columnIncomeMonthDate = "incomeMonthDate";
  // static const columnIncomeDayDate = "incomeDayDate";
  // static const columnIncomeNowDate = "incomeNowDate";

  static final PastYearsDb instance = PastYearsDb();

  static Database? _database;

  Future<Database> get database async {
    // _database ?? await initDB();
    // return _database!;
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
        incomeList TEXT,
        expenseList TEXT
    )
      ''');
    print("Created tables");
  }

  insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(dbTable, row);
  }

  Future<List<PastYearModel>> queryDatabase() async {
    Database db = await instance.database;
    var result = await db.query(dbTable);
    return result.map((item) => PastYearModel.fromMap(item)).toList();
  }
}