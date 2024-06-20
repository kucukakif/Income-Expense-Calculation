import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:salary_planning/helpers/income_db.dart';
import 'package:salary_planning/models/expense.dart';
import 'package:salary_planning/models/income.dart';

import '../local_data/month_data.dart';

class IncomeProvider with ChangeNotifier {
  List<IncomeModel> _incomeItems = [];

  List<IncomeModel> get items {
    return [..._incomeItems];
  }

  Future<void> addIncome(
      int amount,
      String categoriName,
      String explanation,
      String date,
      String yearDate,
      String monthDate,
      String dayDate,
      String now) async {
    final income = IncomeModel(
        income: amount,
        categoriName: categoriName,
        explanation: explanation,
        date: date,
        yearDate: yearDate,
        monthDate: monthDate,
        dayDate: dayDate,
        now: now);
    _incomeItems.add(income);
    notifyListeners();
    try {
      await IncomeDB.instance.insert({
        IncomeDB.columnIncome: income.income,
        IncomeDB.columnCategoriName: income.categoriName,
        IncomeDB.columnExplanation: income.explanation,
        IncomeDB.columnDate: income.date,
        IncomeDB.columnYearDate: income.yearDate,
        IncomeDB.columnMonthDate: income.monthDate,
        IncomeDB.columnDayDate: income.dayDate,
        IncomeDB.columnNowDate: income.now
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<IncomeModel>> getIncome() async {
    final data = await IncomeDB.instance.queryDatabase();
    notifyListeners();
    return data;
  }

  Future<void> deleteIncome(IncomeModel model, int id) async {
    _incomeItems.remove(model);
    notifyListeners();
    await IncomeDB.instance.deleteIncome(id);
  }

  Future<void> fetchAndSetIncome() async {
    final dataList = await IncomeDB.instance.queryDatabase();
    _incomeItems = dataList
        .map((item) => IncomeModel(
            income: item.income,
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

  Future<int> monthTotalIncome() async {
    var mapList = await IncomeDB.instance.queryDatabase();
    List<int> list = [];
    int totalIncome = 0;
    String monthDate = DateFormat.LLLL().format(DateTime.now());
    for (int i = 0; i < mapList.length; i++) {
      if (mapList[i].monthDate == monthDate) {
        list.add(mapList[i].income!);
      }
    }
    try {
      totalIncome = list.reduce((i, j) => i + j);
    } catch (e) {
      print(e);
    }
    return totalIncome;
  }

  Future<Map<List<IncomeModel>, int>> beforeMonthsIncome() async {
    final incomeData = await IncomeDB().queryDatabase();
    Map<List<IncomeModel>, int> mapList = {};

    List<IncomeModel> inJanuaryList = [];
    int januaryTotal = 0;
    List<IncomeModel> inFebruaryList = [];
    int februaryTotal = 0;
    List<IncomeModel> inMarchList = [];
    int marchTotal = 0;
    List<IncomeModel> inAprilList = [];
    int aprilTotal = 0;
    List<IncomeModel> inMayList = [];
    int mayTotal = 0;
    List<IncomeModel> inJuneList = [];
    int juneTotal = 0;
    List<IncomeModel> inJulyList = [];
    int julyTotal = 0;
    List<IncomeModel> inAugustList = [];
    int augustTotal = 0;
    List<IncomeModel> inSeptemberList = [];
    int septemberTotal = 0;
    List<IncomeModel> inOctoberList = [];
    int octoberTotal = 0;
    List<IncomeModel> inNovemberList = [];
    int novemberTotal = 0;
    List<IncomeModel> inDecemberList = [];
    int decemberTotal = 0;

    List<int> januaryIncomeList = [];
    List<int> februaryIncomeList = [];
    List<int> marchIncomeList = [];
    List<int> aprilIncomeList = [];
    List<int> mayIncomeList = [];
    List<int> juneIncomeList = [];
    List<int> julyIncomeList = [];
    List<int> augustIncomeList = [];
    List<int> septemberIncomeList = [];
    List<int> octoberIncomeList = [];
    List<int> novemberIncomeList = [];
    List<int> decemberIncomeList = [];

    for (int i = 0; i < incomeData.length; i++) {
      if (incomeData[i].monthDate == month_data[0]) {
        inJanuaryList.add(incomeData[i]);
        januaryIncomeList.add(incomeData[i].income!);
        januaryTotal =
            januaryIncomeList.fold(januaryIncomeList.length, (i, j) => i + j) -
                januaryIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[1]) {
        inFebruaryList.add(incomeData[i]);
        februaryIncomeList.add(incomeData[i].income!);
        februaryTotal = februaryIncomeList.fold(
                februaryIncomeList.length, (i, j) => i + j) -
            februaryIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[2]) {
        inMarchList.add(incomeData[i]);
        marchIncomeList.add(incomeData[i].income!);
        marchTotal =
            marchIncomeList.fold(marchIncomeList.length, (i, j) => i + j) -
                marchIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[3]) {
        inAprilList.add(incomeData[i]);
        aprilIncomeList.add(incomeData[i].income!);
        aprilTotal =
            aprilIncomeList.fold(aprilIncomeList.length, (i, j) => i + j) -
                aprilIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[4]) {
        inMayList.add(incomeData[i]);
        mayIncomeList.add(incomeData[i].income!);
        mayTotal = mayIncomeList.fold(mayIncomeList.length, (i, j) => i + j) -
            mayIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[5]) {
        inJuneList.add(incomeData[i]);
        juneIncomeList.add(incomeData[i].income!);
        juneTotal =
            juneIncomeList.fold(juneIncomeList.length, (i, j) => i + j) -
                juneIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[6]) {
        inJulyList.add(incomeData[i]);
        julyIncomeList.add(incomeData[i].income!);
        julyTotal =
            julyIncomeList.fold(julyIncomeList.length, (i, j) => i + j) -
                julyIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[7]) {
        inAugustList.add(incomeData[i]);
        augustIncomeList.add(incomeData[i].income!);
        augustTotal =
            augustIncomeList.fold(augustIncomeList.length, (i, j) => i + j) -
                augustIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[8]) {
        inSeptemberList.add(incomeData[i]);
        septemberIncomeList.add(incomeData[i].income!);
        septemberTotal = septemberIncomeList.fold(
                septemberIncomeList.length, (i, j) => i + j) -
            septemberIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[9]) {
        inOctoberList.add(incomeData[i]);
        octoberIncomeList.add(incomeData[i].income!);
        octoberTotal =
            octoberIncomeList.fold(octoberIncomeList.length, (i, j) => i + j) -
                octoberIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[10]) {
        inNovemberList.add(incomeData[i]);
        novemberIncomeList.add(incomeData[i].income!);
        novemberTotal = novemberIncomeList.fold(
                novemberIncomeList.length, (i, j) => i + j) -
            novemberIncomeList.length;
      } else if (incomeData[i].monthDate == month_data[11]) {
        inDecemberList.add(incomeData[i]);
        decemberIncomeList.add(incomeData[i].income!);
        decemberTotal = decemberIncomeList.fold(
                decemberIncomeList.length, (i, j) => i + j) -
            decemberIncomeList.length;
      }
    }
    if (inJanuaryList.isNotEmpty) {
      mapList.addAll({inJanuaryList: januaryTotal});
    }
    if (inFebruaryList.isNotEmpty) {
      mapList.addAll({inFebruaryList: februaryTotal});
    }
    if (inMarchList.isNotEmpty) {
      mapList.addAll({inMarchList: marchTotal});
    }
    if (inAprilList.isNotEmpty) {
      mapList.addAll({inAprilList: aprilTotal});
    }
    if (inMayList.isNotEmpty) {
      mapList.addAll({inMayList: mayTotal});
    }
    if (inJuneList.isNotEmpty) {
      mapList.addAll({inJuneList: juneTotal});
    }
    if (inJulyList.isNotEmpty) {
      mapList.addAll({inJulyList: julyTotal});
    }
    if (inAugustList.isNotEmpty) {
      mapList.addAll({inAugustList: augustTotal});
    }
    if (inSeptemberList.isNotEmpty) {
      mapList.addAll({inSeptemberList: septemberTotal});
    }
    if (inOctoberList.isNotEmpty) {
      mapList.addAll({inOctoberList: octoberTotal});
    }
    if (inNovemberList.isNotEmpty) {
      mapList.addAll({inNovemberList: novemberTotal});
    }
    if (inDecemberList.isNotEmpty) {
      mapList.addAll({inDecemberList: decemberTotal});
    }
    notifyListeners();
    return mapList;
  }
}
