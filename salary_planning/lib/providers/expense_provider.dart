import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:salary_planning/local_data/month_data.dart';
import '../helpers/expense_db.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<ExpenseModel> _expenseItems = [];

  List<ExpenseModel> get items {
    return [..._expenseItems];
  }

  Future<void> addExpense(
      int id,
      int spend,
      int amount,
      String categoriName,
      String explanation,
      String time,
      String yearDate,
      String monthDate,
      String dayDate,
      String now) async {
    final expense = ExpenseModel(
        id: id,
        spend: spend,
        amount: amount,
        categoriName: categoriName,
        explanation: explanation,
        date: time,
        yearDate: yearDate,
        monthDate: monthDate,
        dayDate: dayDate,
        now: now);
    _expenseItems.add(expense);
    notifyListeners();
    try {
      await ExpenseDB.instance.insert({
        ExpenseDB.columnExpense: expense.spend,
        ExpenseDB.columnAmount: expense.amount,
        ExpenseDB.columnCategoriName: expense.categoriName,
        ExpenseDB.columnExplanation: expense.explanation,
        ExpenseDB.columnDate: expense.date,
        ExpenseDB.columnyearDate: expense.yearDate,
        ExpenseDB.columnMonthDate: expense.monthDate,
        ExpenseDB.columnDayDate: expense.dayDate,
        ExpenseDB.columnNowDate: expense.now,
      });
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ExpenseModel> findItem(String categoriName) async {
    final dataList = await ExpenseDB.instance.queryDatabase();
    ExpenseModel? expenseModel;
    for (var element in dataList) {
      if (element.categoriName == categoriName) {
        expenseModel = element;
        notifyListeners();
      }
    }

    

    return expenseModel ??
        ExpenseModel(
            id: 0,
            spend: 0,
            amount: 0,
            categoriName: "",
            explanation: "",
            date: "",
            yearDate: "",
            monthDate: "",
            dayDate: "",
            now: "");
  }

  Future<List<ExpenseModel>> getExpense() async {
    final data = await ExpenseDB.instance.queryDatabase();
    notifyListeners();
    return data;
  }

  Future<ExpenseModel> findItemId(String categoriname) async {
    final dataList = await ExpenseDB.instance.queryDatabase();
    ExpenseModel? expenseModel;
    for (var element in dataList) {
      if (element.categoriName == categoriname) {
        expenseModel = element;
        notifyListeners();
      }
    }

    return expenseModel ??
        ExpenseModel(
            id: 0,
            spend: 0,
            amount: 0,
            categoriName: "",
            explanation: "",
            date: "",
            yearDate: "",
            monthDate: "",
            dayDate: "",
            now: "");
  }

  Future<void> fetchAndSetExpense() async {
    final dataList = await ExpenseDB.instance.queryDatabase();
    _expenseItems = dataList
        .map((item) => ExpenseModel(
            id: item.id,
            spend: item.spend,
            amount: item.amount,
            categoriName: item.categoriName,
            explanation: item.explanation,
            date: item.date,
            yearDate: item.yearDate,
            monthDate: item.monthDate,
            dayDate: item.dayDate,
            now: item.now))
        .toList();
    notifyListeners();
  }

  Future<Map<String, double>> todayData(List<ExpenseModel> categoryList) async {
    Map<String, double> list = {};
    String dayDate = DateFormat.MMMMd().format(DateTime.now());
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList[i].dayDate == dayDate) {
        list.addAll({
          categoryList[i].categoriName:
              double.parse(categoryList[i].spend.toString())
        });
      }
    }
    return list;
  }

  Future<List<ExpenseModel>> todayCategoryData() async {
    final categoryList = await ExpenseDB().queryDatabase();
    List<ExpenseModel> list = [];
    String dayDate = DateFormat.MMMMd().format(DateTime.now());
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList[i].dayDate == dayDate) {
        list.add(categoryList[i]);
      }
    }
    return list;
  }

  Future<Map<String, double>> monthData(List<ExpenseModel> expenseList) async {
    Map<String, double> list = {};
    String monthDate = DateFormat.LLLL().format(DateTime.now());
    for (int i = 0; i < expenseList.length; i++) {
      if (expenseList[i].monthDate == monthDate) {
        list.addAll({
          expenseList[i].categoriName:
              double.parse(expenseList[i].spend.toString())
        });
      }
    }
    notifyListeners();
    return list;
  }

  Future<int> thisMonthTotalExpense() async {
    var mapList = await ExpenseDB.instance.queryDatabase();
    List<int> list = [];
    int totalExpense = 0;
    String monthDate = DateFormat.LLLL().format(DateTime.now());
    for (int i = 0; i < mapList.length; i++) {
      if (mapList[i].monthDate == monthDate) {
        list.add(mapList[i].spend);
      }
    }
    try {
      totalExpense = list.reduce((i, j) => i + j);
    } catch (e) {
      print(e);
    }
    return totalExpense;
  }

  Future<int> thisWeekTotalExpense() async {
    var mapList = await ExpenseDB.instance.queryDatabase();
    List<int> list = [];
    int totalExpense = 0;
    String monthDate = DateFormat.LLLL().format(DateTime.now());
    for (int i = 0; i < mapList.length; i++) {
      if (mapList[i].monthDate == monthDate) {
        list.add(mapList[i].spend);
      }
    }
    DateTime today = DateTime.now();
    DateTime firstDayOfTheweek =
        today.subtract(Duration(days: today.weekday - 1));
    print(firstDayOfTheweek.day);
    totalExpense = list.reduce((i, j) => i + j);
    return totalExpense;
  }

  Future<void> deleteExpense(ExpenseModel model, int id) async {
    _expenseItems.remove(model);
    notifyListeners();
    await ExpenseDB.instance.deleteData(id);
  }

  Future<Map<List<ExpenseModel>, int>> beforeMonthsExpenses() async {
    final expenseData = await ExpenseDB().queryDatabase();
    Map<List<ExpenseModel>, int> mapList = {};

    List<ExpenseModel> exJanuaryList = [];
    int januaryTotal = 0;
    List<ExpenseModel> exFebruaryList = [];
    int februaryTotal = 0;
    List<ExpenseModel> exMarchList = [];
    int marchTotal = 0;
    List<ExpenseModel> exAprilList = [];
    int aprilTotal = 0;
    List<ExpenseModel> exMayList = [];
    int mayTotal = 0;
    List<ExpenseModel> exJuneList = [];
    int juneTotal = 0;
    List<ExpenseModel> exJulyList = [];
    int julyTotal = 0;
    List<ExpenseModel> exAugustList = [];
    int augustTotal = 0;
    List<ExpenseModel> exSeptemberList = [];
    int septemberTotal = 0;
    List<ExpenseModel> exOctoberList = [];
    int octoberTotal = 0;
    List<ExpenseModel> exNovemberList = [];
    int novemberTotal = 0;
    List<ExpenseModel> exDecemberList = [];
    int decemberTotal = 0;

    List<int> januarySpendList = [];
    List<int> februarySpendList = [];
    List<int> marchSpendList = [];
    List<int> aprilSpendList = [];
    List<int> maySpendList = [];
    List<int> juneSpendList = [];
    List<int> julySpendList = [];
    List<int> augustSpendList = [];
    List<int> septemberSpendList = [];
    List<int> octoberSpendList = [];
    List<int> novemberSpendList = [];
    List<int> decemberSpendList = [];

    for (int i = 0; i < expenseData.length; i++) {
      if (expenseData[i].monthDate == month_data[0]) {
        exJanuaryList.add(expenseData[i]);
        januarySpendList.add(expenseData[i].spend);
        januaryTotal =
            januarySpendList.fold(januarySpendList.length, (i, j) => i + j) -
                januarySpendList.length;
      } else if (expenseData[i].monthDate == month_data[1]) {
        exFebruaryList.add(expenseData[i]);
        februarySpendList.add(expenseData[i].spend);
        februaryTotal =
            februarySpendList.fold(februarySpendList.length, (i, j) => i + j) -
                februarySpendList.length;
      } else if (expenseData[i].monthDate == month_data[2]) {
        exMarchList.add(expenseData[i]);
        marchSpendList.add(expenseData[i].spend);
        marchTotal =
            marchSpendList.fold(marchSpendList.length, (i, j) => i + j) -
                marchSpendList.length;
      } else if (expenseData[i].monthDate == month_data[3]) {
        exAprilList.add(expenseData[i]);
        aprilSpendList.add(expenseData[i].spend);
        aprilTotal =
            aprilSpendList.fold(aprilSpendList.length, (i, j) => i + j) -
                aprilSpendList.length;
      } else if (expenseData[i].monthDate == month_data[4]) {
        exMayList.add(expenseData[i]);
        maySpendList.add(expenseData[i].spend);
        mayTotal = maySpendList.fold(maySpendList.length, (i, j) => i + j) -
            maySpendList.length;
      } else if (expenseData[i].monthDate == month_data[5]) {
        exJuneList.add(expenseData[i]);
        juneSpendList.add(expenseData[i].spend);
        juneTotal = juneSpendList.fold(juneSpendList.length, (i, j) => i + j) -
            juneSpendList.length;
      } else if (expenseData[i].monthDate == month_data[6]) {
        exJulyList.add(expenseData[i]);
        julySpendList.add(expenseData[i].spend);
        julyTotal = julySpendList.fold(julySpendList.length, (i, j) => i + j) -
            julySpendList.length;
      } else if (expenseData[i].monthDate == month_data[7]) {
        exAugustList.add(expenseData[i]);
        augustSpendList.add(expenseData[i].spend);
        augustTotal =
            augustSpendList.fold(augustSpendList.length, (i, j) => i + j) -
                augustSpendList.length;
      } else if (expenseData[i].monthDate == month_data[8]) {
        exSeptemberList.add(expenseData[i]);
        septemberSpendList.add(expenseData[i].spend);
        septemberTotal = septemberSpendList.fold(
                septemberSpendList.length, (i, j) => i + j) -
            septemberSpendList.length;
      } else if (expenseData[i].monthDate == month_data[9]) {
        exOctoberList.add(expenseData[i]);
        octoberSpendList.add(expenseData[i].spend);
        octoberTotal =
            octoberSpendList.fold(octoberSpendList.length, (i, j) => i + j) -
                octoberSpendList.length;
      } else if (expenseData[i].monthDate == month_data[10]) {
        exNovemberList.add(expenseData[i]);
        novemberSpendList.add(expenseData[i].spend);
        novemberTotal =
            novemberSpendList.fold(novemberSpendList.length, (i, j) => i + j) -
                novemberSpendList.length;
      } else if (expenseData[i].monthDate == month_data[11]) {
        exDecemberList.add(expenseData[i]);
        decemberSpendList.add(expenseData[i].spend);
        decemberTotal =
            decemberSpendList.fold(decemberSpendList.length, (i, j) => i + j) -
                decemberSpendList.length;
      }
    }
    if (exJanuaryList.isNotEmpty) {
      mapList.addAll({exJanuaryList: januaryTotal});
    }
    if (exFebruaryList.isNotEmpty) {
      mapList.addAll({exFebruaryList: februaryTotal});
    }
    if (exMarchList.isNotEmpty) {
      mapList.addAll({exMarchList: marchTotal});
    }
    if (exAprilList.isNotEmpty) {
      mapList.addAll({exAprilList: aprilTotal});
    }
    if (exMayList.isNotEmpty) {
      mapList.addAll({exMayList: mayTotal});
    }
    if (exJuneList.isNotEmpty) {
      mapList.addAll({exJuneList: juneTotal});
    }
    if (exJulyList.isNotEmpty) {
      mapList.addAll({exJulyList: julyTotal});
    }
    if (exAugustList.isNotEmpty) {
      mapList.addAll({exAugustList: augustTotal});
    }
    if (exSeptemberList.isNotEmpty) {
      mapList.addAll({exSeptemberList: septemberTotal});
    }
    if (exOctoberList.isNotEmpty) {
      mapList.addAll({exOctoberList: octoberTotal});
    }
    if (exNovemberList.isNotEmpty) {
      mapList.addAll({exNovemberList: novemberTotal});
    }
    if (exDecemberList.isNotEmpty) {
      mapList.addAll({exDecemberList: decemberTotal});
    }
    notifyListeners();
    return mapList;
  }
}
