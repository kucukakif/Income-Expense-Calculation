import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salary_planning/helpers/expense_db.dart';
import 'package:salary_planning/models/expense.dart';
import 'package:salary_planning/models/income.dart';
import 'package:salary_planning/providers/income_provider.dart';
import 'package:salary_planning/screens/main_page.dart';

class PastIncomesAndExpenses extends StatefulWidget {
  const PastIncomesAndExpenses({super.key});

  @override
  State<PastIncomesAndExpenses> createState() => _PastIncomesAndExpensesState();
}

List<IncomeModel> incomeList1 = [];
List<ExpenseModel> expenseList1 = [];

class _PastIncomesAndExpensesState extends State<PastIncomesAndExpenses> {
  int length = 0;
  List<IncomeModel> incomeList = [];
  List<ExpenseModel> expenseList = [];

  List<String> categoriList = [];
  List<String> explanationList = [];
  List<String> dateList = [];
  List<String> monthList = [];
  List<bool> typeList = [];
  List<String> moneyList = [];

  bool explantiontext = false;

  initFunction1() async {
    if (incomeList1.isEmpty && expenseList1.isEmpty) {
      incomeList1 =
          await Provider.of<IncomeProvider>(context, listen: false).getIncome();
      expenseList1 = await ExpenseDB.instance.queryDatabase();
    }
  }

  monthNameFunction() async {}

  initFunction() async {
    if (todayFilter == true) {
      initFunction1();
    }
    if (!mounted) return;
    setState(() {
      incomeList = incomeList1;
      expenseList = expenseList1;
      length = expenseList.length + incomeList.length;
    });
    if (incomeList.isNotEmpty) {
      for (int i = 0; i < incomeList.length; i++) {
        setState(() {
          categoriList.add(incomeList[i].categoriName!);
          explanationList.add(incomeList[i].explanation);
          dateList.add(incomeList[i].dayDate!);
          monthList.add(incomeList[i].monthDate!);
          typeList.add(true);
          moneyList.add(incomeList[i].income.toString());
        });
      }
    }
    if (expenseList.isNotEmpty) {
      for (int i = 0; i < expenseList.length; i++) {
        setState(() {
          categoriList.add(expenseList[i].categoriName);
          explanationList.add(expenseList[i].explanation!);
          dateList.add(expenseList[i].dayDate!);
          monthList.add(expenseList[i].monthDate!);
          typeList.add(false);
          moneyList.add(expenseList[i].spend.toString());
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initFunction();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.01),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: const Color.fromARGB(255, 221, 194, 144),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            List<String> textList = dateList[index].split(' ');
            String text = "";
            String date = "";
            if (textList[0] == "January") {
              text = "Ocak";
              date = textList[1] + " " + text;
            } else if (textList[0] == "February") {
              text = "Şubat";
              date = textList[1] + " " + text;
            } else if (textList[0] == "March") {
              text = "Mart";
              date = textList[1] + " " + text;
            } else if (textList[0] == "April") {
              text = "Nisan";
              date = textList[1] + " " + text;
            } else if (textList[0] == "May") {
              text = "Mayıs";
              date = textList[1] + " " + text;
            } else if (textList[0] == "June") {
              text = "Haziran";
              date = textList[1] + " " + text;
            } else if (textList[0] == "July") {
              text = "Temmuz";
              date = textList[1] + " " + text;
            } else if (textList[0] == "August") {
              text = "Ağustos";
              date = textList[1] + " " + text;
            } else if (textList[0] == "September") {
              text = "Eylül";
              date = textList[1] + " " + text;
            } else if (textList[0] == "October") {
              text = "Ekim";
              date = textList[1] + " " + text;
            } else if (textList[0] == "November") {
              text = "Kasım";
              date = textList[1] + " " + text;
            } else if (textList[0] == "December") {
              text = "Aralık";
              date = textList[1] + " " + text;
            }
            textList.clear();
            return categoriList.isEmpty
                ? const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Geçmiş yok",
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  )
                : InkWell(
                    onDoubleTap: () {},
                    child: Container(
                      height: height > 800 ? height * 0.09 : height * 0.11,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.01),
                      margin: EdgeInsets.symmetric(vertical: height * 0.007),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: explanationList[index] == ""
                                    ? height > 800
                                        ? 15
                                        : 20
                                    : height > 800
                                        ? 0
                                        : 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categoriList[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                  ),
                                ),
                                explanationList[index] != ""
                                    ? Text(
                                        explanationList[index],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                    fontSize: 19, color: Colors.black),
                              ),
                              Text(
                                '${moneyList[index]}₺',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: typeList[index] == true
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
          },
          itemCount: length == 0 ? 1 : length,
        ),
      ),
    );
  }
}
