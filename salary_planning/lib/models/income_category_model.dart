class IncomeCategoryModel {
  final String name;
  IncomeCategoryModel({required this.name});

  factory IncomeCategoryModel.fromMap(Map<String, dynamic> map) {
    return IncomeCategoryModel(name: map['categoryName'].toString());
  }
}
