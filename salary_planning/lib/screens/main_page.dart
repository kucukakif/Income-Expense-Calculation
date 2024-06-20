import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:salary_planning/helpers/expense_category_db.dart';
import 'package:salary_planning/helpers/expense_today_db.dart';
import 'package:salary_planning/helpers/incomeCategory_db.dart';
import 'package:salary_planning/helpers/income_db.dart';
import 'package:salary_planning/local_data/income_data.dart';
import 'package:salary_planning/models/expense.dart';
import 'package:salary_planning/models/income.dart';
import 'package:salary_planning/providers/expense_provider.dart';
import 'package:salary_planning/providers/income_provider.dart';
import 'package:salary_planning/screens/expense_screen.dart';
import 'package:salary_planning/screens/past_incpmes_and_expenses.dart';
import 'package:salary_planning/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/expense_db.dart';
import '../local_data/expense_data.dart';
import '../models/expense_category_model.dart';
import '../providers/expense_category_provider.dart';
import '../providers/income-category_provider.dart';
import 'income_screen.dart';

class MainPage extends StatefulWidget {
  static const routeName = "/wagePage";
  final int index;
  const MainPage({super.key, this.index = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

bool? todayFilter;
late Future<Map<String, double>> dataMap;

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index != 0 ? widget.index : 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _balance();
      firstData();
      firstData1();
      function1();
      bottomSheetCategories();
      pastScreenFunction();
    });
  }

  function1() async {
    final incomeCategoryData = await IncomeCategoryDB.instance.queryDatabase();
    final expenseCategoryData =
        await ExpenseCategoryDB.instance.queryDatabase();
    for (int i = 0; i < incomeCategoryData.length; i++) {
      if (i % 2 == 0) {
        setState(() {
          shakeList.add(ShakeDefaultConstant1());
        });
      } else {
        setState(() {
          shakeList.add(ShakeDefaultConstant2());
        });
      }
    }
    for (int i = 0; i < expenseCategoryData.length; i++) {
      if (i % 2 == 0) {
        setState(() {
          shakeList1.add(ShakeDefaultConstant1());
        });
      } else {
        setState(() {
          shakeList1.add(ShakeDefaultConstant2());
        });
      }
    }
  }

  firstData1() async {
    final expenseCategoryProvider =
        await ExpenseCategoryDB.instance.queryDatabase();
    if (expenseCategoryProvider.isEmpty) {
      for (int i = 0; i < expenseKategoryData.length; i++) {
        await ExpenseCategoryProvider()
            .addExpenseCategory(expenseKategoryData[i], 'false');
      }
      for (int i = 0; i < expenseKategoryData.length; i++) {
        if (i % 2 == 0) {
          setState(() {
            shakeList1.add(ShakeDefaultConstant1());
          });
        } else {
          setState(() {
            shakeList1.add(ShakeDefaultConstant2());
          });
        }
      }
    }
  }

  firstData() async {
    final incomeCategoryProvider =
        await IncomeCategoryDB.instance.queryDatabase();
    if (incomeCategoryProvider.isEmpty) {
      for (int i = 0; i < incomeKategoryData.length; i++) {
        await IncomeCategoryProvider().addIncomeCategory(incomeKategoryData[i]);
      }
      for (int i = 0; i < incomeKategoryData.length; i++) {
        if (i % 2 == 0) {
          setState(() {
            shakeList.add(ShakeDefaultConstant1());
          });
        } else {
          setState(() {
            shakeList.add(ShakeDefaultConstant2());
          });
        }
      }
    }
  }

  pastScreenFunction() async {
    if (incomeList1.isEmpty && expenseList1.isEmpty) {
      incomeList1 =
          await Provider.of<IncomeProvider>(context, listen: false).getIncome();
      expenseList1 = await ExpenseDB.instance.queryDatabase();
    }
  }

  bottomSheetCategories() async {
    var expenseCategoryData1 = await ExpenseCategoryDB.instance.queryDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenseCategoryData = expenseCategoryData1;
    });
    boolList.add(incomeCheck);
    boolList.add(expenseCheck);
    for (int i = 0; i < expenseCategoryData.length; i++) {
      categoryBoolList.add(false);
    }
    boolList.add(todayCheck);
    boolList.add(thisWeekCheck);
    boolList.add(thisMonthCheck);
    for (int i = 0; i < boolList.length; i++) {
      setState(() {
        prefs.setBool(i.toString(), boolList[i]);
      });
    }
  }

  sharedPrefAndUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < boolList.length; i++) {
      prefs.setBool(i.toString(), boolList[i]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      if (!mounted) {
        return;
      }
      expenseProvider = Provider.of<ExpenseProvider>(context);
      dataMap = expenseProvider!.todayData(expenseData);
      isInit = false;
    }
  }

  List<ExpenseModel> expenseData = [];
  _balance() async {
    await IncomeProvider().beforeMonthsIncome();
    await ExpenseProvider().beforeMonthsExpenses();
    final categoryList = await ExpenseDB.instance.queryDatabase();
    if (!mounted) {
      return;
    }
    setState(() {
      expenseData = categoryList;
    });
  }

  pieChart() async {
    final categoryList = await ExpenseDB.instance.queryDatabase();
    final data = await ExpenseProvider()
        .todayData(expenseData2.isEmpty ? categoryList : expenseData2);
    if (!mounted) {
      return;
    }
    setState(() {
      pieChartData = data;
    });
  }

  buttonFunction() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const MainPage(
                    index: 3,
                  )));
    });
  }

  void _incrementCounter() {
    setState(() {
      autoPlay = !autoPlay;
    });
  }

  void _incrementCounter1() {
    setState(() {
      autoPlay1 = !autoPlay1;
    });
  }

  int? balance;
  int? _currentIndex;

  bool incomeCheck = false;
  bool todayCheck = false;
  bool thisWeekCheck = false;
  bool thisMonthCheck = false;
  bool expenseCheck = false;
  bool bottomSheet = false;
  var isInit = true;

  List<ExpenseCategoryModel> expenseCategoryData = [];
  List<bool> boolList = [];
  List<bool> categoryBoolList = [];
  List<String> checkedCategoryNames = [];

  ExpenseProvider? expenseProvider;

  final List<Widget> _pagesList = [
    const MainPageBody(),
    const IncomeScreen(),
    const ExpenseScreen(),
    const PastIncomesAndExpenses(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: const Color.fromARGB(255, 221, 197, 152),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BottomNavigationBar(
          elevation: 2,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 221, 197, 152),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: "Ana Sayfa",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Gelir"),
            BottomNavigationBarItem(icon: Icon(Icons.remove), label: "Gider"),
            BottomNavigationBarItem(
                icon: Icon(Icons.assessment_outlined), label: "Geçmiş"),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Ayarlar",
            ),
          ],
          currentIndex: _currentIndex!,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (_currentIndex == 3) {
              setState(() {
                todayFilter = true;
              });
            }
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          selectedLabelStyle:
              const TextStyle(color: Colors.white, fontSize: 17),
          unselectedLabelStyle:
              const TextStyle(color: Colors.black, fontSize: 17),
          selectedIconTheme: const IconThemeData(color: Colors.white, size: 29),
          unselectedIconTheme: const IconThemeData(color: Colors.black),
        ),
      ),
      floatingActionButton: _currentIndex == 3
          ? FloatingActionButton.extended(
              onPressed: () async {
                final incomeData = await IncomeDB.instance.queryDatabase();
                final expenseData = await ExpenseDB.instance.queryDatabase();
                setState(() {
                  incomeList1 = incomeData;
                  expenseList1 = expenseData;
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MainPage(
                                index: 3,
                              )));
                });
              },
              label: const Text(
                "Filtreyi Sıfırla",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ))
          : null,
      appBar: _currentIndex == 0
          ? null
          : AppBar(
              leading: const SizedBox(),
              elevation: _currentIndex == 4 ? 0 : 1,
              title: _currentIndex == 4
                  ? const Text(
                      "Sayın Kullanıcı",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  : null,
              centerTitle: true,
              actions: [
                _currentIndex == 1
                    ? Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: IconButton(
                            onPressed: () {
                              _incrementCounter();
                            },
                            icon: const Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                              size: 27.5,
                            )),
                      )
                    : const SizedBox(),
                _currentIndex == 2
                    ? Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: IconButton(
                            onPressed: () {
                              _incrementCounter1();
                            },
                            icon: const Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                              size: 27.5,
                            )),
                      )
                    : const SizedBox(),
                _currentIndex == 3
                    ? Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: IconButton(
                            onPressed: () async {
                              var expenseCategoryData1 = await ExpenseCategoryDB
                                  .instance
                                  .queryDatabase();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              for (int i = 0; i < boolList.length; i++) {
                                setState(() {
                                  prefs.setBool(i.toString(), boolList[i]);
                                });
                              }
                              // ignore: use_build_context_synchronously
                              showModalBottomSheet(
                                context: context,
                                enableDrag: true,
                                isDismissible: false,
                                isScrollControlled: true,
                                builder: (context) => Container(
                                  height: height > 700
                                      ? height * 0.88
                                      : height * 0.93,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: height * 0.011,
                                        width: width * 0.15,
                                        margin: const EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey.shade400),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.3,
                                            vertical: height * 0.05),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      const Text(
                                        "Tipe Göre",
                                        style: TextStyle(
                                            fontSize: 23, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      SizedBox(
                                        height: height > 700
                                            ? height * 0.145
                                            : height * 0.150,
                                        width: double.infinity,
                                        child: StatefulBuilder(
                                          builder: (ctx, setState) => Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.04,
                                                  ),
                                                  Checkbox(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      value: incomeCheck,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          incomeCheck = value!;
                                                          boolList.first =
                                                              value;
                                                        });
                                                      }),
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                                  const Text(
                                                    "Gelirleri Göster",
                                                    style:
                                                        TextStyle(fontSize: 21),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.04,
                                                  ),
                                                  Checkbox(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      value: expenseCheck,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          expenseCheck = value!;
                                                          for (int i = 0;
                                                              i <
                                                                  boolList
                                                                      .length;
                                                              i++) {
                                                            if (i == 1) {
                                                              boolList[i] =
                                                                  value;
                                                            }
                                                          }
                                                        });
                                                      }),
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                                  const Text(
                                                    "Giderleri Göster",
                                                    style:
                                                        TextStyle(fontSize: 21),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Kategoriye Göre",
                                        style: TextStyle(
                                            fontSize: height > 800 ? 23 : 22,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Container(
                                        height: height * 0.3,
                                        decoration: BoxDecoration(
                                            color: Colors.purple.shade50,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemBuilder: (ctx, index) {
                                            return StatefulBuilder(
                                              builder: (ctx, setState) => Row(
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.04,
                                                  ),
                                                  Checkbox(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      value: categoryBoolList[
                                                          index],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          categoryBoolList[
                                                              index] = value!;
                                                        });
                                                        checkedCategoryNames.add(
                                                            expenseCategoryData[
                                                                    index]
                                                                .name!);
                                                      }),
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                                  Text(
                                                    expenseCategoryData[index]
                                                        .name!,
                                                    style: const TextStyle(
                                                        fontSize: 21),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount: expenseCategoryData.length,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Tarihe Göre",
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      StatefulBuilder(
                                        builder: (ctx, setState) => Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width * 0.04,
                                                ),
                                                Checkbox(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    value: todayCheck,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        todayCheck = value!;
                                                        for (int i = 0;
                                                            i < boolList.length;
                                                            i++) {
                                                          if (i ==
                                                              expenseCategoryData1
                                                                      .length +
                                                                  1) {
                                                            boolList[i] = value;
                                                          }
                                                        }
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                const Text(
                                                  "Bugün",
                                                  style:
                                                      TextStyle(fontSize: 21),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width * 0.04,
                                                ),
                                                Checkbox(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    value: thisWeekCheck,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        thisWeekCheck = value!;
                                                        for (int i = 0;
                                                            i < boolList.length;
                                                            i++) {
                                                          if (i ==
                                                              expenseCategoryData1
                                                                      .length +
                                                                  2) {
                                                            boolList[i] = value;
                                                          }
                                                        }
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                const Text(
                                                  "Bu Hafta",
                                                  style:
                                                      TextStyle(fontSize: 21),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width * 0.04,
                                                ),
                                                Checkbox(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    value: thisMonthCheck,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        thisMonthCheck = value!;
                                                        for (int i = 0;
                                                            i < boolList.length;
                                                            i++) {
                                                          if (i ==
                                                              expenseCategoryData1
                                                                      .length +
                                                                  3) {
                                                            boolList[i] = value;
                                                          }
                                                        }
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                const Text(
                                                  "Bu Ay",
                                                  style:
                                                      TextStyle(fontSize: 21),
                                                ),
                                              ],
                                            ),
                                            // SizedBox(
                                            //   height: height > 800
                                            //       ? height * 0.02
                                            //       : height * 0.01,
                                            // ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                String monthDate =
                                                    DateFormat.LLLL()
                                                        .format(DateTime.now());
                                                String dayDate =
                                                    DateFormat.MMMMd()
                                                        .format(DateTime.now());
                                                final incomeData =
                                                    await IncomeDB.instance
                                                        .queryDatabase();
                                                final expenseData =
                                                    await ExpenseDB.instance
                                                        .queryDatabase();
                                                if (incomeCheck == true) {
                                                  // Gelir göster butonu
                                                  if (categoryBoolList
                                                          .contains(true) ==
                                                      true) {
                                                    // ignore: use_build_context_synchronously
                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Hata"),
                                                            content: const Text(
                                                                "Bu şekilde filtreleme yapılamaz!"),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      "Tamam"))
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    setState(() {
                                                      incomeList1 = incomeData;
                                                      expenseList1 = [];
                                                    });
                                                    buttonFunction();
                                                  }
                                                } else if (expenseCheck ==
                                                    true) {
                                                  // Gider göster butonu
                                                  if (categoryBoolList
                                                          .contains(true) ==
                                                      true) {
                                                    expenseList1 = [];
                                                    for (int y = 0;
                                                        y < expenseData.length;
                                                        y++) {
                                                      if (expenseCategoryData
                                                              // ignore: iterable_contains_unrelated_type
                                                              .contains(
                                                                  expenseData[y]
                                                                      .categoriName) ==
                                                          true) {
                                                      } else {
                                                        // ignore: use_build_context_synchronously
                                                        showDialog(
                                                            context: context,
                                                            builder: (ctx) {
                                                              return AlertDialog(
                                                                title:
                                                                    const Text(
                                                                        "Hata"),
                                                                content: const Text(
                                                                    "Bu şekilde filtreleme yapılamaz!"),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          "Tamam"))
                                                                ],
                                                              );
                                                            });
                                                        break;
                                                      }
                                                    }
                                                  } else {
                                                    setState(() {
                                                      incomeList1 = [];
                                                      expenseList1 =
                                                          expenseData;
                                                    });
                                                    buttonFunction();
                                                  }
                                                } else if (incomeCheck ==
                                                        true &&
                                                    expenseCheck == true) {
                                                  // Gelir ve gider butonları
                                                  setState(() {
                                                    incomeList1 = incomeData;
                                                    expenseList1 = expenseData;
                                                  });
                                                  buttonFunction();
                                                } else if (categoryBoolList
                                                        .contains(true) ==
                                                    true) {
                                                  // Kategoriye göre
                                                  expenseList1 = [];
                                                  for (int y = 0;
                                                      y < expenseData.length;
                                                      y++) {
                                                    for (int x = 0;
                                                        x <
                                                            checkedCategoryNames
                                                                .length;
                                                        x++) {
                                                      if (expenseData[y]
                                                              .categoriName ==
                                                          checkedCategoryNames[
                                                              x]) {
                                                        setState(() {
                                                          expenseList1.add(
                                                              expenseData[y]);
                                                        });
                                                        setState(() {
                                                          incomeList1 = [];
                                                        });
                                                      }
                                                    }
                                                  }
                                                  if (expenseList1 == []) {
                                                    // ignore: use_build_context_synchronously
                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Hata"),
                                                            content: const Text(
                                                                "Bu kategoride bir harcama yapılmamış."),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      "Tamam"))
                                                            ],
                                                          );
                                                        });
                                                  }
                                                  buttonFunction();
                                                } else if (todayCheck == true) {
                                                  // Bugünü filtreleme
                                                  setState(() {
                                                    incomeList1 = [];
                                                    expenseList1 = [];
                                                  });
                                                  for (int i = 0;
                                                      i < expenseData.length;
                                                      i++) {
                                                    if (expenseData[i]
                                                            .dayDate ==
                                                        dayDate) {
                                                      expenseList1
                                                          .add(expenseData[i]);
                                                    }
                                                  }
                                                  for (int i = 0;
                                                      i < incomeData.length;
                                                      i++) {
                                                    if (incomeData[i].dayDate ==
                                                        dayDate) {
                                                      incomeList1
                                                          .add(incomeData[i]);
                                                    }
                                                  }
                                                  setState(() {
                                                    todayFilter = false;
                                                  });
                                                  buttonFunction();
                                                } else if (thisMonthCheck ==
                                                    true) {
                                                  // Bu ayı filtreleme
                                                  setState(() {
                                                    incomeList1 = [];
                                                    expenseList1 = [];
                                                  });
                                                  for (int i = 0;
                                                      i < expenseData.length;
                                                      i++) {
                                                    if (expenseData[i]
                                                            .monthDate ==
                                                        monthDate) {
                                                      expenseList1
                                                          .add(expenseData[i]);
                                                    }
                                                  }
                                                  for (int i = 0;
                                                      i < incomeData.length;
                                                      i++) {
                                                    if (incomeData[i]
                                                            .monthDate ==
                                                        monthDate) {
                                                      incomeList1
                                                          .add(incomeData[i]);
                                                    }
                                                  }
                                                  setState(() {
                                                    todayFilter = false;
                                                  });
                                                  buttonFunction();
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.purple,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  shadowColor: Colors.black),
                                              child: const Text(
                                                "Filtrele",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 27.5,
                            )),
                      )
                    : const SizedBox(),
              ],
              shape: _currentIndex == 4
                  ? const RoundedRectangleBorder()
                  : const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35)),
                    ),
              backgroundColor: const Color.fromARGB(255, 37, 134, 141),
            ),
      body: _pagesList[_currentIndex!],
    );
  }
}

List<ExpenseModel> expenseData2 = [];
List<String> pageTrueList = [];
Map<String, double> pieChartData = {};

class MainPageBody extends StatefulWidget {
  static const routeName = '/mainPageBody';
  const MainPageBody({super.key});

  @override
  State<MainPageBody> createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {
  Map<List<ExpenseModel>, int> exMapList = {};
  Map<List<IncomeModel>, int> inMapList = {};
  List<ExpenseModel> expenseData = [];
  Map<String, double> firstTodayData = {};
  List<bool> boolList = [];
  List<String> nameList = [];
  Map<int, bool> trueList = {};
  int? expense;
  int? balance1;
  int balance = 0;

  month() async {
    final incomeMonthData = await IncomeProvider().beforeMonthsIncome();
    final expenseMonthData = await ExpenseProvider().beforeMonthsExpenses();
    if (mounted) {
      setState(() {
        exMapList = Map.fromEntries(expenseMonthData.entries.toList().reversed);
        inMapList = Map.fromEntries(incomeMonthData.entries.toList().reversed);
        for (int i = 0; i < inMapList.length; i++) {
          if (i != exMapList.length) {
            exMapList.addAll({
              [
                ExpenseModel(
                    id: 0,
                    spend: 0,
                    amount: 0,
                    categoriName: "",
                    explanation: "",
                    date: "",
                    yearDate: "",
                    monthDate: "",
                    dayDate: "",
                    now: "")
              ]: 0
            });
          }
        }
      });
    }
  }

  sharedPrefAndUpdate() async {
    for (int i = 0; i < boolList.length; i++) {
      trueList.addAll({i: boolList[i]});
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var element in trueList.entries) {
      if (element.value == true) {
        ExpenseCategoryDB.instance.updateData(
          expenseData[element.key == 0 ? 0 : element.key - 1].categoriName,
          "true",
          element.key,
        );
      } else {
        ExpenseCategoryDB.instance.updateData(
          expenseData[element.key == 0 ? 0 : element.key - 1].categoriName,
          "false",
          element.key,
        );
      }
      prefs.setBool("bolValue", element.value);
    }
  }

  _balance() async {
    final categoryList = await ExpenseDB.instance.queryDatabase();
    final todayExpenseTotal = await ExpenseDB().todayExpenseTotal();
    await IncomeProvider().beforeMonthsIncome();
    await ExpenseProvider().beforeMonthsExpenses();
    final incomeTotal = await IncomeProvider().monthTotalIncome();
    final expenseTotal = await ExpenseProvider().thisMonthTotalExpense();
    int total = incomeTotal - expenseTotal;
    if (!mounted) {
      return;
    }
    setState(() {
      expenseData = categoryList;
      expense = todayExpenseTotal;
      balance = total;
    });
  }

  expenseTodayDBClear() async {
    final categoryList = await ExpenseTodayDB.instance.queryDatabase();
    for (int i = 0; i < categoryList.length; i++) {
      ExpenseTodayDB.instance.deleteData(i);
    }
  }

  data() async {}

  pieChart() async {
    final categoryList = await ExpenseTodayDB.instance.queryDatabase();
    final data = await ExpenseProvider()
        .todayData(expenseData2.isEmpty ? categoryList : expenseData2);

    if (!mounted) {
      return;
    }
    setState(() {
      firstTodayData = data;
      pieChartData = data;
    });
  }

  boolList1() async {
    final categoryList = await ExpenseCategoryDB.instance.queryDatabase();
    for (int i = 0; i < categoryList.length; i++) {
      if (!mounted) {
        return;
      }
      setState(() {
        // ignore: sdk_version_since
        boolList.add(bool.parse(categoryList[i].value!));
      });
    }
  }

  function() async {
    int totalSpend = 0;
    String yearDate = DateFormat.y().format(DateTime.now());
    String month = DateFormat.LLLL().format(DateTime.now());
    String dayDate = DateFormat.MMMMd().format(DateTime.now());
    DateTime now = DateTime.now();
    String date = DateFormat.jm().format(DateTime.now());
    sharedPrefAndUpdate();
    if (pieChartData.isNotEmpty) {
      for (int i = 0; i < boolList.length; i++) {
        if (boolList[i] == true) {
          ExpenseModel expense =
              await ExpenseProvider().findItem(expenseData[i].categoriName);
          checkedList.add(expense);
        } else {
          if (nameList.contains(expenseData[i].categoriName)) {
            ExpenseModel unCheckedExpense =
                await ExpenseProvider().findItemId(expenseData[i].categoriName);
            unCheckedList.add(unCheckedExpense);
          }
        }
      }
      for (int i = 0; i < unCheckedList.length; i++) {
        totalSpend = totalSpend + unCheckedList[i].spend;
      }
      month = month;
      dayDate = dayDate;
      yearDate = yearDate;
      date = date;
      if (checkedList.isNotEmpty) {
        checkedList.add(ExpenseModel(
            id: checkedList.last.id! + 1,
            spend: totalSpend,
            amount: 0,
            categoriName: "diğer",
            explanation: "",
            date: date,
            yearDate: yearDate,
            monthDate: month,
            dayDate: dayDate,
            now: now.toString()));
      }
      setState(() {
        expenseData2 = checkedList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _balance();
      month();
      boolList1();
      pieChart();
      function();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> data = {"": 0};
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          child: Container(
            width: width * 1,
            height: height * 0.28,
            padding: EdgeInsets.only(top: height > 700 ? height * 0.04 : 20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 37, 134, 141),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35)),
            ),
            child: Column(
              children: [
                const Text(
                  "Kalan",
                  style: TextStyle(color: Colors.black, fontSize: 23),
                ),
                Text(
                  "$balance₺",
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 100,
          child: Container(
              width: width * 1,
              height: height * 0.25,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 37, 134, 141),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
              ),
              child: Container()),
        ),
        Positioned(
          top: height > 700 ? 105 : 80,
          child: Container(
            height: height * 0.42,
            width: width * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.white,
            ),
            child: FutureBuilder<Map<String, double>>(
                future: dataMap,
                builder: (ctx, value) {
                  return Column(
                    children: [
                      SizedBox(
                        height: height * 0.03,
                      ),
                      SizedBox(
                        height: height * 0.34,
                        child: PieChart(
                          chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: true,
                              chartValueStyle:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          legendOptions: const LegendOptions(
                              showLegends: true,
                              legendPosition: LegendPosition.bottom,
                              showLegendsInRow: true),
                          chartType: ChartType.ring,
                          animationDuration: const Duration(milliseconds: 1500),
                          dataMap: pieChartData.isEmpty ? data : pieChartData,
                          centerText:
                              pieChartData.isEmpty ? "Gider yok" : '$expense ₺',
                          centerTextStyle: TextStyle(
                            fontSize: pieChartData.isEmpty ? 16 : 22,
                            color: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      // Container(
                      //   height: height * 0.05,
                      //   alignment: Alignment.centerRight,
                      //   margin: EdgeInsets.only(top: height * 0.025),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       TextButton(
                      //           onPressed: () async {
                      //             if (expenseData2.isNotEmpty) {
                      //               unCheckedList.clear();
                      //               checkedList.clear();
                      //               for (var element in boolList) {
                      //                 setState(() {
                      //                   element == false;
                      //                 });
                      //               }
                      //               expenseData2 ==
                      //                   await ExpenseDB.instance
                      //                       .queryDatabase();
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (ctx) => MainPage()));
                      //             }
                      //           },
                      //           child: const Text(
                      //             "Filtreyi Temizle",
                      //             style: TextStyle(
                      //                 fontSize: 18, color: Colors.purple),
                      //           )),
                      //       IconButton(
                      //           onPressed: () {
                      //             showConfirmationDialog(context, height);
                      //           },
                      //           icon: const Icon(Icons.more_vert))
                      //     ],
                      //   ),
                      // ),
                    ],
                  );
                }),
          ),
        ),
        Positioned(
            top: height * 0.59,
            child: Container(
              alignment: Alignment.topCenter,
              height: height * 0.29,
              width: width * 1.05,
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  String monthName = "";
                  if (inMapList.keys.elementAt(i)[0].monthDate! == "January") {
                    monthName = "Ocak";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "February") {
                    monthName = "Şubat";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "March") {
                    monthName = "Mart";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "April") {
                    monthName = "Nisan";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "May") {
                    monthName = "Mayıs";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "June") {
                    monthName = "Haziran";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "July") {
                    monthName = "Temmuz";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "August") {
                    monthName = "Ağustos";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "September") {
                    monthName = "Eylül";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "October") {
                    monthName = "Ekim";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "November") {
                    monthName = "Kasım";
                  } else if (inMapList.keys.elementAt(i)[0].monthDate! ==
                      "December") {
                    monthName = "Aralık";
                  }
                  return Container(
                    height: height > 750 ? height * 0.07 : height * 0.075,
                    margin:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(2, 2),
                          blurRadius: 5,
                        )
                      ],
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.grey.shade300,
                    ),
                    padding: const EdgeInsets.only(
                        right: 25, left: 25, top: 7, bottom: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          monthName,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                        Column(
                          children: [
                            Text(
                              '${inMapList.values.elementAt(i)}₺',
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 19),
                            ),
                            Text(
                              '${exMapList.values.elementAt(i)}₺',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 19),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: inMapList.keys.length,
              ),
            )),
      ],
    );
  }

  Future<dynamic> showConfirmationDialog(BuildContext context, double height) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return CustomDialog(
            boolList: boolList,
            pieChartData: pieChartData,
          );
        });
  }

  GestureDetector _graphicTopText(
      String text, double underlineWidth, VoidCallback onTap) {
    double width2 = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: width2 * 0.003),
            width: underlineWidth,
            height: 3,
            color: const Color.fromARGB(255, 37, 134, 141),
          )
        ],
      ),
    );
  }
}

List<ExpenseModel> checkedList = [];
List<ExpenseModel> unCheckedList = [];

class CustomDialog extends StatefulWidget {
  final List<bool> boolList;
  final Map<String, double> pieChartData;
  const CustomDialog(
      {super.key, required this.boolList, required this.pieChartData});

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  List<ExpenseCategoryModel> expenseData = [];
  List<ExpenseCategoryModel> expenseData3 = [];
  List<ExpenseModel> expenseModelData = [];
  Map<int, bool> trueList = {};
  List<String> boolList2 = [];
  @override
  void initState() {
    super.initState();
    loadSwitchValue();
  }

  loadSwitchValue() async {
    final categoryList = await ExpenseCategoryDB.instance.queryDatabase();
    final expenseDb = await ExpenseDB().queryDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      expenseModelData = expenseDb;
      expenseData = categoryList;
    });
    final now = DateFormat.MMMMd().format(DateTime.now());
    for (int i = 0; i < expenseDb.length; i++) {
      if (expenseDb[i].dayDate == now) {
        expenseData3.add(ExpenseCategoryModel(
            name: expenseDb[i].categoriName, value: 'false'));
      }
    }
    for (int i = 0; i < widget.boolList.length; i++) {
      setState(() {
        (prefs.getBool(
              expenseData[i].name!,
            )) ??
            false;
      });
    }
  }

  sharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < widget.boolList.length; i++) {
      setState(() {
        prefs.setBool(expenseData[i].name!, widget.boolList[i]);
      });
    }
  }

  sharedPrefAndUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var element in trueList.entries) {
      if (element.value == true) {
        ExpenseCategoryDB.instance.updateData(
          expenseData[element.key == 0 ? 0 : element.key - 1].name!,
          "true",
          element.key,
        );
      } else {
        ExpenseCategoryDB.instance.updateData(
          expenseData[element.key == 0 ? 0 : element.key - 1].name!,
          "false",
          element.key,
        );
      }
      prefs.setBool("bolValue", element.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text(
          "Tabloda Görmek İstediğin Kategorileri Seç",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        content: SizedBox(
          width: double.minPositive,
          height: height * 0.5,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (ctx, index) {
              return CheckboxListTile(
                value: widget.boolList[index],
                onChanged: (value) {
                  setState(() {
                    widget.boolList[index] = value!;
                    trueList.addAll({index: widget.boolList[index]});
                    sharedPref();
                  });
                },
                title: Text(
                  expenseData[index].name!,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
            itemCount: expenseData.length,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Geri Gel",
                style: TextStyle(color: Colors.purple, fontSize: 18),
              )),
          TextButton(
              onPressed: () async {
                if (expenseData.isNotEmpty) {
                  int totalSpend = 0;
                  String yearDate = DateFormat.y().format(DateTime.now());
                  String month = DateFormat.LLLL().format(DateTime.now());
                  String dayDate = DateFormat.MMMMd().format(DateTime.now());
                  String date = DateFormat.jm().format(DateTime.now());
                  sharedPrefAndUpdate();
                  for (int i = 0; i < expenseModelData.length; i++) {
                    if (dayDate == expenseModelData[i].dayDate) {
                      for (int x = 0; x < widget.boolList.length; x++) {
                        if (widget.boolList[x] == false) {
                          boolList2.add(expenseModelData[i].categoriName);
                        }
                      }
                    }
                  }
                  for (int i = 0; i < widget.boolList.length; i++) {
                    if (widget.boolList[i] == true) {
                      ExpenseModel expense = await ExpenseProvider()
                          .findItem(expenseData[i].name!);
                      setState(() {
                        checkedList.add(expense);
                      });
                    } else {
                      if (boolList2.contains(expenseData[i].name)) {
                        ExpenseModel unCheckedExpense = await ExpenseProvider()
                            .findItemId(expenseData[i].name!);
                        setState(() {
                          unCheckedList.add(unCheckedExpense);
                        });
                      }
                    }
                  }
                  for (int i = 0; i < unCheckedList.length; i++) {
                    totalSpend = totalSpend + unCheckedList[i].spend;
                  }
                  month = month;
                  dayDate = dayDate;
                  yearDate = yearDate;
                  date = date;
                }
                for (int i = 0; i < widget.boolList.length; i++) {
                  if (widget.boolList[i] == true) {
                    pageTrueList.add(expenseData[i].name!);
                  }
                }
                setState(() {
                  expenseData2 = checkedList;
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const MainPage()));
              },
              child: const Text(
                "Kaydet",
                style: TextStyle(color: Colors.purple, fontSize: 18),
              )),
        ],
      ),
    );
  }
}
