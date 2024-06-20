import 'package:flutter/foundation.dart';
import 'package:salary_planning/helpers/income_lowCategories_db.dart';

import '../models/income_low_categoriy_model.dart';

class IncomeLowCategoryProvider with ChangeNotifier {
  final List<IncomeLowCategoriyModel> _list = [];

  List<IncomeLowCategoriyModel> get items {
    return [..._list];
  }

  Future<void> addIncomeLowCategory(
      String categoryName, String lowCategoryName) async {
    final expenseLowCategory = IncomeLowCategoriyModel(
        categoryname: categoryName, lowCategoryName: lowCategoryName);
    _list.add(expenseLowCategory);
    notifyListeners();
    IncomeLowCategoriesDB.instance.insert({
      IncomeLowCategoriesDB.columnCategoryname: categoryName,
      IncomeLowCategoriesDB.columnLowCategoryName: lowCategoryName
    });
  }

  Future<List<IncomeLowCategoriyModel>> queryLowCategory(
      String categoryName) async {
    List<IncomeLowCategoriyModel> categoryList = [];
    final lowCategoryData =
        await IncomeLowCategoriesDB.instance.queryDatabase();
    for (int i = 0; i < lowCategoryData.length; i++) {
      if (categoryName == lowCategoryData[i].categoryname) {
        categoryList.add(lowCategoryData[i]);
      }
    }
    print(lowCategoryData);
    return categoryList;
  }

  Future<void> removeIncomeLowCategory(
      int id, IncomeLowCategoriyModel expenseLowCategoriesModel) async {
    _list.remove(expenseLowCategoriesModel);
    await IncomeLowCategoriesDB.instance.deleteData(id);
  }
}
