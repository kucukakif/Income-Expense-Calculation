import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:salary_planning/helpers/expense_category_db.dart';
import 'package:salary_planning/helpers/incomeCategory_db.dart';
import 'package:salary_planning/local_data/income_data.dart';
import 'package:salary_planning/providers/expense_provider.dart';
import 'package:salary_planning/providers/income_provider.dart';
import 'package:salary_planning/screens/expense_screen.dart';
import 'package:salary_planning/screens/income_add_screen.dart';
import '../models/income_category_model.dart';
import '../providers/income-category_provider.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

bool autoPlay = false;
List<ShakeConstant> shakeList = [];

class _IncomeScreenState extends State<IncomeScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      function();
      _balance();
    });
  }

  final incomeLowerCategoryController = TextEditingController();
  final incomeCategoryController = TextEditingController();

  List<IncomeCategoryModel> incomeCategoryList = [];

  int balance = 0;

  Duration? duration;

  

  function() async {
    final incomeCategoryData = await IncomeCategoryDB.instance.queryDatabase();
    try {
      setState(() {
        incomeCategoryList = incomeCategoryData;
      });
    } catch (e) {
      print(e);
    }
  }

  _balance() async {
    await IncomeProvider().beforeMonthsIncome();
    await ExpenseProvider().beforeMonthsExpenses();
    final incomeTotal = await IncomeProvider().monthTotalIncome();
    final expenseTotal = await ExpenseProvider().thisMonthTotalExpense();
    int total = incomeTotal - expenseTotal;
    try {
      setState(() {
        balance = total;
      });
    } catch (e) {
      print(e);
    }
  }

  String incomeCategoryname = "";

  int initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
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
                  "Gelir Kategori",
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: SizedBox(
                height: height * 0.45,
                width: double.infinity,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (ctx, i) {
                    return (i != incomeCategoryList.length)
                        ? ShakeWidget(
                            duration: duration,
                            autoPlay: autoPlay,
                            shakeConstant: shakeList[i],
                            child: GestureDetector(
                              onTap: () {
                                if (autoPlay == true) {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: const Text("Bilgi"),
                                          content: Text(
                                              "${incomeCategoryList[i].name} kategorisini silmek istiyor musunuz ?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  await IncomeCategoryProvider()
                                                      .deleteIncomeCategory(
                                                          incomeCategoryList[i]
                                                              .name,
                                                          i);
                                                  setState(() {
                                                    autoPlay = !autoPlay;
                                                  });
                                                  final expenseCategoryData =
                                                      await IncomeCategoryDB
                                                          .instance
                                                          .queryDatabase();
                                                  setState(() {
                                                    incomeCategoryList =
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
                                          builder: (context) => IncomeAddScreen(
                                                categoryname:
                                                    incomeCategoryList[i].name,
                                                id: i,
                                              )));
                                }
                                setState(() {
                                  incomeCategoryname =
                                      incomeCategoryList[i].name;
                                });
                              },
                              child: Container(
                                width: 55,
                                height: 55,
                                margin: const EdgeInsets.all(9),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  incomeCategoryList[i].name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              showDialog(
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
                                              controller:
                                                  incomeCategoryController,
                                              decoration: const InputDecoration
                                                  .collapsed(
                                                hintText:
                                                    "Kategori İsmini Giriniz",
                                                hintStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 37, 134, 141),
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                              if (incomeCategoryController
                                                  .text.isEmpty) {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text("Hata"),
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
                                                if (incomeCategoryList.contains(
                                                        incomeCategoryController
                                                            .text) ==
                                                    true) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Hata"),
                                                          content: const Text(
                                                              "Bu isimde kategori var"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Tamam"))
                                                          ],
                                                        );
                                                      });
                                                } else {
                                                  IncomeCategoryProvider()
                                                      .addIncomeCategory(
                                                          incomeCategoryController
                                                              .text);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                    "Kategori eklendi.",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )));

                                                  if (i % 2 == 0) {
                                                    setState(() {
                                                      shakeList.add(
                                                          ShakeDefaultConstant1());
                                                    });
                                                  } else {
                                                    setState(() {
                                                      shakeList.add(
                                                          ShakeDefaultConstant2());
                                                    });
                                                  }
                                                  incomeCategoryController
                                                      .text = "";
                                                }
                                              }

                                              final expenseCategoryData =
                                                  await IncomeCategoryDB
                                                      .instance
                                                      .queryDatabase();
                                              setState(() {
                                                incomeCategoryList =
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
                                margin: const EdgeInsets.all(9),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(
                                  Icons.add,
                                  size: 30,
                                )),
                          );
                  },
                  itemCount: incomeCategoryList.length + 1,
                ),
              ),
            ),
          ],
        ));
  }
}
