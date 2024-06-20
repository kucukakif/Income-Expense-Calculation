class ExpenseCategoryModel {
  final String? name;
  final String? value;
  ExpenseCategoryModel({required this.name, required this.value});

  factory ExpenseCategoryModel.fromMap(Map<String, dynamic> map) {
    return ExpenseCategoryModel(
      name: map['categoryName'].toString(),
      value: map['value'],
    );
  }
}
