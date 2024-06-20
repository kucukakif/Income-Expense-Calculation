class ExpenseLowCategoriyModel {
  final String categoryname;
  final String lowCategoryName;
  ExpenseLowCategoriyModel(
      {required this.categoryname, required this.lowCategoryName});

  factory ExpenseLowCategoriyModel.fromMap(Map<String, dynamic> map) {
    return ExpenseLowCategoriyModel(
        categoryname: map['categoryName'].toString(),
        lowCategoryName: map['lowCategoryName'].toString());
  }
}
