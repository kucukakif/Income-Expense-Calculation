class PastYearModel {
  String? incomeList;
  String? expenseList;

  PastYearModel({required this.incomeList, required this.expenseList});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['incomeList'] = incomeList;
    map['expenseList'] = expenseList;
    return map;
  }

  factory PastYearModel.fromMap(Map<String, dynamic> map) {
    return PastYearModel(
        incomeList: map['incomeList'], expenseList: map['expenseList']);
  }
}
