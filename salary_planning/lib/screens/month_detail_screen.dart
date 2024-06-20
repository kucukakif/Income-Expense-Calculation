import 'package:flutter/material.dart';
import 'package:salary_planning/models/expense.dart';

import '../models/income.dart';

// ignore: must_be_immutable
class MonthDetailScreen extends StatefulWidget {
  List<IncomeModel> incomeList = [];
  List<ExpenseModel> expenseList = [];
  String monthName;
  MonthDetailScreen(
      {required this.incomeList,
      required this.expenseList,
      required this.monthName});

  @override
  State<MonthDetailScreen> createState() => _MonthDetailScreenState();
}

bool incomeOrExpense = false;
List<IncomeModel> incomeList = [];
List<ExpenseModel> expenseList = [];

class _MonthDetailScreenState extends State<MonthDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      function();
    });
  }

  List<String> categoriList = [];
  List<String> explanationList = [];
  List<String> dateList = [];
  List<String> monthList = [];
  List<bool> typeList = [];
  List<String> moneyList = [];

  function() async {
    if (widget.expenseList.isNotEmpty) {
      for (int i = 0; i < widget.expenseList.length; i++) {
        setState(() {
          categoriList.add(widget.expenseList[i].categoriName);
          explanationList.add(widget.expenseList[i].explanation!);
          dateList.add(widget.expenseList[i].dayDate!);
          monthList.add(widget.expenseList[i].monthDate!);
          typeList.add(false);
          moneyList.add(widget.expenseList[i].spend.toString());
        });
      }
    }

    for (int i = 0; i < widget.incomeList.length; i++) {
      setState(() {
        categoriList.add(widget.incomeList[i].categoriName!);
        explanationList.add(widget.incomeList[i].explanation);
        dateList.add(widget.incomeList[i].dayDate!);
        monthList.add(widget.incomeList[i].monthDate!);
        typeList.add(true);
        moneyList.add(widget.incomeList[i].income.toString());
      });
    }
    print(categoriList);
    print(explanationList);
    print(dateList);
    print(monthList);
    print(typeList);
    print(moneyList);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 221, 197, 152),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 37, 134, 141),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35))),
          title: Text(
            "${widget.monthName} Ay'ının Grafiği",
            style: const TextStyle(fontSize: 21),
          ),
          centerTitle: true,
        ),
        body: SizedBox(
            height: double.infinity,
            child: ListView(children: [
              Container(
                width: double.infinity,
                height: height * 0.07,
                margin: const EdgeInsets.only(
                    left: 8, right: 8, top: 10, bottom: 3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Filtrele",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: moneyList.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onDoubleTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: height * 0.11,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(3, 3),
                                color: Colors.black26,
                                blurRadius: 3,
                                spreadRadius: 1)
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (explanationList[i] == "")
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categoriList[i],
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ],
                            )
                          else if (explanationList[i].length > 30)
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoriList[i],
                                    style: const TextStyle(fontSize: 19),
                                  ),
                                  Expanded(
                                    child: Text(
                                      explanationList[i],
                                      style: const TextStyle(fontSize: 17),
                                      maxLines: 4,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoriList[i],
                                    style: const TextStyle(fontSize: 19),
                                  ),
                                  Text(
                                    explanationList[i],
                                    style: const TextStyle(fontSize: 17),
                                    maxLines: 4,
                                  ),
                                ],
                              ),
                            ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                dateList[i],
                                style: const TextStyle(fontSize: 18),
                              ),
                              Row(
                                children: [
                                  typeList[i] == true
                                      ? const Text(
                                          "Income:",
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.green),
                                        )
                                      : const Text(
                                          "Expense:",
                                          style: TextStyle(
                                              fontSize: 19, color: Colors.red),
                                        ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Text(
                                    '${moneyList[i]} ₺',
                                    style: const TextStyle(fontSize: 18),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ])));
  }
}
