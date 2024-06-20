import 'package:flutter/widgets.dart';

import '../helpers/incomeCategory_db.dart';
import '../models/income_category_model.dart';

class IncomeCategoryProvider with ChangeNotifier {
  List<IncomeCategoryModel> incomeCategoryList = [];

  List<IncomeCategoryModel> get items {
    return [...incomeCategoryList];
  }

  Future<void> addIncomeCategory(String categoryName) async {
    incomeCategoryList.add(IncomeCategoryModel(name: categoryName));
    notifyListeners();
    await IncomeCategoryDB.instance
        .insert({IncomeCategoryDB.columnCategoryName: categoryName});
  }

  Future<void> deleteIncomeCategory(String categoryName, int id) async {
    incomeCategoryList.remove(categoryName);
    notifyListeners();
    await IncomeCategoryDB.instance.deleteData(categoryName);
  }

  Future<void> fetchAndSetIncomeCategory() async {
    final dataList = await IncomeCategoryDB.instance.queryDatabase();
    incomeCategoryList =
        dataList.map((item) => IncomeCategoryModel(name: item.name)).toList();
    notifyListeners();
  }
}
