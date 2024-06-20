import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:salary_planning/local_data/expense_data.dart';
import 'package:salary_planning/providers/expense_provider.dart';
import 'package:salary_planning/providers/income_provider.dart';
import 'package:salary_planning/screens/expense_add_screen.dart';
import 'package:salary_planning/screens/main_page.dart';
import '../helpers/expense_category_db.dart';
import '../models/expense_category_model.dart';
import '../providers/expense_category_provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

bool autoPlay1 = false;
List<ShakeConstant> shakeList1 = [];

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      function();
      _balance();
    });
  }

  int balance = 0;
  _balance() async {
    await IncomeProvider().beforeMonthsIncome();
    await ExpenseProvider().beforeMonthsExpenses();
    final incomeTotal = await IncomeProvider().monthTotalIncome();
    final expenseTotal = await ExpenseProvider().thisMonthTotalExpense();
    int total = incomeTotal - expenseTotal;
    if (mounted) {
      setState(() {
        balance = total;
      });
    }
  }

  

  function() async {
    final expenseCategoryData =
        await ExpenseCategoryDB.instance.queryDatabase();
    if (mounted) {
      setState(() {
        expenseCategoryList = expenseCategoryData;
      });
    }
  }

  List<ExpenseCategoryModel> expenseCategoryList = [];
  String expenseCategoryname = "";
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final expenseCategoryController = TextEditingController();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: const Color.fromARGB(255, 221, 194, 144),
      child: ListView(
        children: [
          SizedBox(
            height: height * 0.02,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Gider Kategori",
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          SizedBox(
            height: height * 0.8,
            width: double.infinity,
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (ctx, i) {
                bool autoPlay = false;
                Duration? duration;
                return (i != expenseCategoryList.length)
                    ? ShakeWidget(
                        duration: duration,
                        shakeConstant: shakeList1[i],
                        autoPlay: autoPlay1,
                        child: GestureDetector(
                          onTap: () {
                            if (autoPlay1 == true) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: const Text("Bilgi"),
                                      content: Text(
                                          "${expenseCategoryList[i].name} kategorisini silmek istiyor musunuz ?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              await ExpenseCategoryProvider()
                                                  .deleteExpenseCategory(
                                                expenseCategoryList[i].name!,
                                              );
                                              setState(() {
                                                autoPlay = !autoPlay;
                                              });
                                              final expenseCategoryData =
                                                  await ExpenseCategoryDB
                                                      .instance
                                                      .queryDatabase();
                                              setState(() {
                                                expenseCategoryList =
                                                    expenseCategoryData;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Evet")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Hayır"))
                                      ],
                                    );
                                  });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExpenseAddScreen(
                                            categoryname:
                                                expenseCategoryList[i].name!,
                                            id: i,
                                          )));
                              setState(() {
                                expenseCategoryname =
                                    expenseCategoryList[i].name!;
                              });
                            }
                          },
                          child: Container(
                            width: 55,
                            height: 55,
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.shade100,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              expenseCategoryList[i].name!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      expenseCategoryList[i].name!.length > 8
                                          ? 16
                                          : 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          showDialog<void>(
                              context: scaffoldKey.currentContext!,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text(
                                    "Kategori Ekle",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  content: SizedBox(
                                    height: height * 0.07,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Kategori İsmi",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        TextField(
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 37, 134, 141),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                          controller: expenseCategoryController,
                                          decoration:
                                              const InputDecoration.collapsed(
                                            hintText: "Kategori İsmini Giriniz",
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 37, 134, 141),
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Geri Gel",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    TextButton(
                                        onPressed: () async {
                                          if (expenseCategoryController
                                              .text.isEmpty) {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    title: const Text("Hata"),
                                                    content: const Text(
                                                        "Kategori ismi boş!"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Tamam"))
                                                    ],
                                                  );
                                                });
                                          } else {
                                            if (expenseCategoryList.contains(
                                                    expenseCategoryController
                                                        .text) ==
                                                true) {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return AlertDialog(
                                                      title: const Text("Hata"),
                                                      content: const Text(
                                                          "Bu isimde kategori var!"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Tamam"))
                                                      ],
                                                    );
                                                  });
                                            } else {
                                              ExpenseCategoryProvider()
                                                  .addExpenseCategory(
                                                expenseCategoryController.text,
                                                'false',
                                              );
                                              expenseCategoryController.text =
                                                  "";
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                "Kategori eklendi.",
                                                style: TextStyle(fontSize: 22),
                                              )));
                                              if (i % 2 == 0) {
                                                setState(() {
                                                  shakeList1.add(
                                                      ShakeDefaultConstant1());
                                                });
                                              } else {
                                                setState(() {
                                                  shakeList1.add(
                                                      ShakeDefaultConstant2());
                                                });
                                              }
                                            }
                                          }
                                          final expenseCategoryData =
                                              await ExpenseCategoryDB.instance
                                                  .queryDatabase();
                                          setState(() {
                                            expenseCategoryList =
                                                expenseCategoryData;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Ekle",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ))
                                  ],
                                );
                              });
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.shade100,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                      );
              },
              itemCount: expenseCategoryList.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
