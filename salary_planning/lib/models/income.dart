class IncomeModel {
  int? income;
  String? categoriName;
  String explanation;
  String? date;
  String? yearDate;
  String? monthDate;
  String? dayDate;
  String? now;

  IncomeModel(
      {required this.income,
      required this.categoriName,
      required this.explanation,
      required this.date,
      required this.yearDate,
      required this.monthDate,
      required this.dayDate,
      required this.now});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['income'] = income;
    map['categoriName'] = categoriName;
    map['explanation'] = explanation;
    map['date'] = date;
    map['yearDate'] = yearDate;
    map['monthDate'] = monthDate;
    map['dayDate'] = dayDate;
    map['nowDate'] = now;
    return map;
  }

  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
        income: int.parse(map['income'].toString()),
        categoriName: map['categoriName'].toString(),
        explanation: map['explanation'].toString(),
        date: map['date'].toString(),
        yearDate: map['yearDate'].toString(),
        monthDate: map['monthDate'].toString(),
        dayDate: map['dayDate'].toString(),
        now: map['nowDate']);
  }
}
