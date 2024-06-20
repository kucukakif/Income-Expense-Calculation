class IncomeLowCategoriyModel {
  final String categoryname;
  final String lowCategoryName;
  IncomeLowCategoriyModel(
      {required this.categoryname, required this.lowCategoryName});

  factory IncomeLowCategoriyModel.fromMap(Map<String, dynamic> map) {
    return IncomeLowCategoriyModel(
        categoryname: map['categoryName'].toString(),
        lowCategoryName: map['lowCategoryName'].toString());
  }
}
