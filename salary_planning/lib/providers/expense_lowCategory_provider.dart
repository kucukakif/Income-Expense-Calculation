import 'package:flutter/foundation.dart';
import 'package:salary_planning/helpers/expense_lowCategories_db.dart';
import 'package:salary_planning/models/expense_low_categoriy_model.dart';

class ExpenseLowCategoryProvider with ChangeNotifier {
  final List<ExpenseLowCategoriyModel> _list = [];

  List<ExpenseLowCategoriyModel> get items {
    return [..._list];
  }

  Future<void> addExpenseLowCategory(
      String categoryName, String lowCategoryName) async {
    final expenseLowCategory = ExpenseLowCategoriyModel(
        categoryname: categoryName, lowCategoryName: lowCategoryName);
    _list.add(expenseLowCategory);
    notifyListeners();
    await ExpenseLowCategoriesDB.instance.insert({
      ExpenseLowCategoriesDB.columnCategoryname:
          expenseLowCategory.categoryname,
      ExpenseLowCategoriesDB.columnLowCategoryName:
          expenseLowCategory.lowCategoryName
    });
  }

  Future<List<ExpenseLowCategoriyModel>> queryLowCategory(
      String categoryName) async {
    List<ExpenseLowCategoriyModel> categoryList = [];
    final lowCategoryData =
        await ExpenseLowCategoriesDB.instance.queryDatabase();
    for (int i = 0; i < lowCategoryData.length; i++) {
      if (categoryName == lowCategoryData[i].categoryname) {
        categoryList.add(lowCategoryData[i]);
      }
    }
    return categoryList;
  }

  Future<void> removeExpenseLowCategory(
      int id, ExpenseLowCategoriyModel expenseLowCategoriesModel) async {
    _list.remove(expenseLowCategoriesModel);
    await ExpenseLowCategoriesDB.instance.deleteData(id);
  }
}
