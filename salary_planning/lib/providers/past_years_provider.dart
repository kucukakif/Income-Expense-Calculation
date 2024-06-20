import 'package:flutter/material.dart';
import 'package:salary_planning/helpers/past_years_db.dart';
import 'package:salary_planning/models/past_year_model.dart';

class PastYearsProvider with ChangeNotifier {
  List<PastYearModel> _pastYearItemse = [];

  List<PastYearModel> get items {
    return [..._pastYearItemse];
  }

  Future<void> addPastYear(String incomeList, String expenseList) async {
    final pastYear =
        PastYearModel(incomeList: incomeList, expenseList: expenseList);
    _pastYearItemse.add(pastYear);
    notifyListeners();
    try {
      await PastYearsDb.instance.insert({
        PastYearsDb.incomeList: incomeList,
        PastYearsDb.expenseList: expenseList,
      });
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
