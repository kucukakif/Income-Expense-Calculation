import 'package:flutter/widgets.dart';

import '../helpers/expense_category_db.dart';
import '../models/expense_category_model.dart';

class ExpenseCategoryProvider extends ChangeNotifier {
  List<ExpenseCategoryModel> _expenseCategoryList = [];

  List<ExpenseCategoryModel> get items {
    return [..._expenseCategoryList];
  }

  Future<void> addExpenseCategory(String categoryName, String value) async {
    _expenseCategoryList
        .add(ExpenseCategoryModel(name: categoryName, value: value));
    notifyListeners();
    await ExpenseCategoryDB.instance.insert({
      ExpenseCategoryDB.columnCategoryName: categoryName,
      ExpenseCategoryDB.columnValue: value
    });
  }

  Future<void> updateExpenseCategory(
      String categoryName, int id, String value) async {
    notifyListeners();
    await ExpenseCategoryDB.instance.updateData(
      categoryName,
      value,
      id,
    );
  }

  Future<void> deleteExpenseCategory(String categoryName) async {
    _expenseCategoryList.remove(categoryName);
    notifyListeners();
    await ExpenseCategoryDB.instance.deleteData(categoryName);
  }

  Future<void> fetchAndSetExpenseCategory() async {
    final dataList = await ExpenseCategoryDB.instance.queryDatabase();
    _expenseCategoryList = dataList
        .map((item) => ExpenseCategoryModel(
              name: item.name,
              value: item.value,
            ))
        .toList();
    notifyListeners();
  }
}