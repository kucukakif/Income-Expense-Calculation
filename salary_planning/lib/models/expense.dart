class ExpenseModel {
  int? id;
  int spend;
  int? amount;
  String categoriName;
  String? explanation;
  String? date;
  String? yearDate;
  String? monthDate;
  String? dayDate;
  String? now;

  ExpenseModel(
      {required this.id,
      required this.spend,
      required this.amount,
      required this.categoriName,
      required this.explanation,
      required this.date,
      required this.yearDate,
      required this.monthDate,
      required this.dayDate,
      required this.now});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['spend'] = spend;
    map['amount'] = amount;
    map['categoriName'] = categoriName;
    map['explanation'] = explanation;
    map['date'] = date;
    map['yearDate'] = yearDate;
    map['monthDate'] = monthDate;
    map['dayDate'] = dayDate;
    map['nowDate'] = now;
    return map;
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
        id: map['id'],
        spend: map['expense'],
        amount: map['amount'],
        categoriName: map['categoriName'],
        explanation: map['explanation'],
        date: map['date'],
        yearDate: map['yearDate'],
        monthDate: map['monthDate'],
        dayDate: map['dayDate'],
        now: map['nowDate']);
  }
}
