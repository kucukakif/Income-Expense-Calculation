import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salary_planning/helpers/expense_db.dart';
import 'package:salary_planning/helpers/expense_lowCategories_db.dart';
import 'package:salary_planning/helpers/expense_today_db.dart';
import 'package:salary_planning/models/expense.dart';
import 'package:salary_planning/models/expense_low_categoriy_model.dart';
import 'package:salary_planning/providers/expense_lowCategory_provider.dart';
import 'package:salary_planning/providers/expense_provider.dart';
import 'package:salary_planning/providers/income_provider.dart';

import 'past_incpmes_and_expenses.dart';

class ExpenseAddScreen extends StatefulWidget {
  final String categoryname;
  final int id;
  const ExpenseAddScreen(
      {super.key, required this.categoryname, required this.id});

  @override
  State<ExpenseAddScreen> createState() => _ExpenseAddScreenState();
}

class _ExpenseAddScreenState extends State<ExpenseAddScreen> {
  final expenseController = TextEditingController();
  final amountController = TextEditingController();
  final explantionController = TextEditingController();
  final lowerExpenseCategoryController = TextEditingController();
  final scaffoldState = GlobalKey<ScaffoldState>();
  String date = "";
  Object lowCategoryName = "";
  String kategoriEkle = "Kategori Ekle";
  List<ExpenseLowCategoriyModel> dataList = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data1();
      lowCategoryData();
    });
  }

  @override
  void dispose() {
    try {
      scaffoldState.currentState!.dispose();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  data1() async {
    String date1 = DateFormat.yMMMMd().format(DateTime.now());
    List<String> textList = date1.split(' ');
    String text = "";

    if (textList[0] == "January") {
      text = "Ocak";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "February") {
      text = "Şubat";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "March") {
      text = "Mart";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "April") {
      text = "Nisan";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "May") {
      text = "Mayıs";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "June") {
      text = "Haziran";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "July") {
      text = "Temmuz";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "August") {
      text = "Ağustos";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "September") {
      text = "Eylül";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "October") {
      text = "Ekim";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "November") {
      text = "Kasım";
      date = textList[1] + " " + text + " " + textList[2];
    } else if (textList[0] == "December") {
      text = "Aralık";
      date = textList[1] + " " + text + " " + textList[2];
    }
  }

  lowCategoryData() async {
    final data = await ExpenseLowCategoryProvider()
        .queryLowCategory(widget.categoryname);
    setState(() {
      dataList = data;
    });
    dataList.add(ExpenseLowCategoriyModel(
        categoryname: widget.categoryname, lowCategoryName: "Kategori Ekle"));
    setState(() {
      lowCategoryName =
          dataList.isEmpty ? "Kategori Ekle" : dataList.first.lowCategoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.categoryname,
            style: const TextStyle(fontSize: 21, color: Colors.white),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35)),
          ),
          backgroundColor: const Color.fromARGB(255, 37, 134, 141),
        ),
        backgroundColor: const Color.fromARGB(255, 221, 194, 144),
        body: Padding(
            padding: EdgeInsets.only(
                top: height * 0.01, left: width * 0.01, right: width * 0.01),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.07,
                ),
                child: Text(
                  date,
                  style: const TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
              SizedBox(
                child: Builder(
                    builder: (ctx) => Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.07,
                              right: width * 0.51,
                              top: height * 0.015),
                          child: DropdownButton(
                              value: lowCategoryName,
                              onChanged: (value) {
                                setState(() {
                                  lowCategoryName = value!;
                                });
                              },
                              isExpanded: true,
                              items: [
                                for (int i = 0; i < dataList.length; i++)
                                  DropdownMenuItem(
                                    value: dataList[i].lowCategoryName,
                                    child: Text(
                                      dataList[i].lowCategoryName,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    onTap: () {
                                      if (dataList[i].lowCategoryName ==
                                          kategoriEkle) {
                                        scaffoldState.currentState!
                                            .showBottomSheet(
                                                (ctx) => Container(
                                                      width: double.infinity,
                                                      height: height * 0.4,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 25,
                                                          vertical: 15),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade300,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30))),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                "Alt Kategori İsmi :",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.03,
                                                              ),
                                                              Expanded(
                                                                child: SizedBox(
                                                                  width: width *
                                                                      0.50,
                                                                  child:
                                                                      TextField(
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black),
                                                                    controller:
                                                                        lowerExpenseCategoryController,
                                                                    decoration:
                                                                        const InputDecoration
                                                                            .collapsed(
                                                                      hintText:
                                                                          "Alt Kategori İsmini Giriniz",
                                                                      hintStyle: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              37,
                                                                              134,
                                                                              141),
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.15,
                                                          ),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (lowerExpenseCategoryController
                                                                    .text
                                                                    .isEmpty) {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (ctx) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text("Hata"),
                                                                          content:
                                                                              const Text("Alt kategori ismi boş!"),
                                                                          actions: [
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text("Tamam"))
                                                                          ],
                                                                        );
                                                                      });
                                                                } else {
                                                                  await ExpenseLowCategoriesDB
                                                                      .instance
                                                                      .insert({
                                                                    ExpenseLowCategoriesDB
                                                                            .columnCategoryname:
                                                                        widget
                                                                            .categoryname,
                                                                    ExpenseLowCategoriesDB
                                                                            .columnLowCategoryName:
                                                                        lowerExpenseCategoryController
                                                                            .text
                                                                  });
                                                                  // ignore: use_build_context_synchronously
                                                                  Navigator.pop(
                                                                      context);
                                                                  lowerExpenseCategoryController
                                                                      .text = "";
                                                                  final data = await ExpenseLowCategoryProvider()
                                                                      .queryLowCategory(
                                                                          widget
                                                                              .categoryname);
                                                                  setState(() {
                                                                    dataList =
                                                                        data;
                                                                    lowCategoryName =
                                                                        dataList
                                                                            .first
                                                                            .lowCategoryName;
                                                                  });
                                                                  dataList.add(ExpenseLowCategoriyModel(
                                                                      categoryname:
                                                                          widget
                                                                              .categoryname,
                                                                      lowCategoryName:
                                                                          "Kategori Ekle"));
                                                                  // ignore: use_build_context_synchronously
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          const SnackBar(
                                                                              content: Text(
                                                                    "Alt Kategori eklendi.",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            22),
                                                                  )));
                                                                }
                                                              },
                                                              child: const Text(
                                                                "Alt Kategori Ekle",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .purple,
                                                                    fontSize:
                                                                        20),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 221, 194, 144));
                                      }
                                    },
                                  ),
                              ]),
                        )),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.07),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_atm,
                      size: 28,
                      color: Colors.green.shade700,
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    SizedBox(
                      width: width * 0.8,
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9\.]"))
                        ],
                        controller: expenseController,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Gider Tutarı",
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 19),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.07),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_atm,
                      size: 28,
                      color: Colors.green.shade700,
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    SizedBox(
                      width: width * 0.8,
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9\.]"))
                        ],
                        controller: amountController,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Gider Miktarı / Adeti",
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 19),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.07),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insert_drive_file_outlined,
                      size: 28,
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    SizedBox(
                      width: width * 0.8,
                      child: TextField(
                        controller: explantionController,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Açıklama",
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 19),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.07,
              ),
              Center(
                child: TextButton(
                    onPressed: () async {
                      String timeDate = DateFormat.jm().format(DateTime.now());
                      String yearDate = DateFormat.y().format(DateTime.now());
                      String monthDate =
                          DateFormat.LLLL().format(DateTime.now());
                      String dayDate =
                          DateFormat.MMMMd().format(DateTime.now());
                      DateTime now = DateTime.now();
                      // final incomeData = await IncomeDB.instance.queryDatabase();
                      final data = await ExpenseDB.instance.queryDatabase();
                      final incomeTotal =
                          await IncomeProvider().monthTotalIncome();
                      final expenseTotal =
                          await ExpenseProvider().thisMonthTotalExpense();
                      int total = incomeTotal - expenseTotal;
                      List<String> categoryNameList = [];
                      for (int i = 0; i < data.length; i++) {
                        if (data[i].dayDate == dayDate) {
                          categoryNameList.add(data[i].categoriName);
                        }
                      }
                      if (expenseController.text.isEmpty) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: const Text("Hata"),
                                content: const Text("Gider girmelisin!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Tamam"))
                                ],
                              );
                            });
                      } else {
                        if (incomeTotal == 0 ||
                            int.parse(expenseController.text) > total) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text("Hata"),
                                  content: const Text("Bakiye yetersiz"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Tamam"))
                                  ],
                                );
                              });
                        } else {
                          int spend1 = 0;
                          String explantion = "";
                          int id1 = 0;
                          for (int i = 0; i < data.length; i++) {
                            if (widget.categoryname == data[i].categoriName) {
                              spend1 = data[i].spend;
                              explantion = data[i].explanation!;
                              id1 = data[i].id!;
                            }
                          }
                          int firstSpend = int.parse(expenseController.text);
                          int totalSpend = spend1 + firstSpend;
                          if (categoryNameList.contains(widget.categoryname) ==
                              true) {
                            for (int i = 0; i < data.length; i++) {
                              if (DateFormat.MMMMd().format(DateTime.now()) ==
                                  dayDate) {
                                int amount = int.parse(
                                    amountController.text == ""
                                        ? "0"
                                        : amountController.text);
                                ExpenseDB.instance.updateData(ExpenseModel(
                                    id: id1,
                                    spend: totalSpend,
                                    amount: amount,
                                    categoriName: widget.categoryname,
                                    explanation:
                                        explantionController.text.isEmpty
                                            ? explantion
                                            : explantionController.text,
                                    date: date,
                                    yearDate: yearDate,
                                    monthDate: monthDate,
                                    dayDate: dayDate,
                                    now: now.toString()));
                                ExpenseTodayDB.instance.updateData(ExpenseModel(
                                    id: id1,
                                    spend: totalSpend,
                                    amount: amount,
                                    categoriName: widget.categoryname,
                                    explanation:
                                        explantionController.text.isEmpty
                                            ? explantion
                                            : explantionController.text,
                                    date: date,
                                    yearDate: yearDate,
                                    monthDate: monthDate,
                                    dayDate: dayDate,
                                    now: now.toString()));
                                expenseController.text = "";
                                explantionController.text = "";
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "Gider güncellendi.",
                                  style: TextStyle(fontSize: 22),
                                )));
                                setState(() {
                                  expenseList1 = [];
                                  incomeList1 = [];
                                });
                                incomeList1 =
                                    // ignore: use_build_context_synchronously
                                    await Provider.of<IncomeProvider>(context,
                                            listen: false)
                                        .getIncome();
                                expenseList1 =
                                    await ExpenseDB.instance.queryDatabase();
                                break;
                              } else {
                                int amount = int.parse(
                                    amountController.text == ""
                                        ? "0"
                                        : amountController.text);
                                ExpenseProvider().addExpense(
                                    widget.id,
                                    int.parse(expenseController.text),
                                    amount,
                                    widget.categoryname,
                                    expenseController.text,
                                    timeDate,
                                    yearDate,
                                    monthDate,
                                    dayDate,
                                    now.toString());
                                ExpenseTodayDB.instance.insert({
                                  ExpenseTodayDB.columnExpense:
                                      int.parse(expenseController.text),
                                  ExpenseTodayDB.columnAmount: amount,
                                  ExpenseTodayDB.columnCategoriName:
                                      widget.categoryname,
                                  ExpenseDB.columnExplanation:
                                      expenseController,
                                  ExpenseDB.columnDate: timeDate,
                                  ExpenseDB.columnyearDate: yearDate,
                                  ExpenseDB.columnMonthDate: monthDate,
                                  ExpenseDB.columnDayDate: dayDate,
                                  ExpenseDB.columnNowDate: now,
                                });
                                expenseController.text = "";
                                explantionController.text = "";
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "Gider Güncellendi.",
                                  style: TextStyle(fontSize: 22),
                                )));
                                setState(() {
                                  expenseList1 = [];
                                  incomeList1 = [];
                                });
                                incomeList1 =
                                    // ignore: use_build_context_synchronously
                                    await Provider.of<IncomeProvider>(context,
                                            listen: false)
                                        .getIncome();
                                expenseList1 =
                                    await ExpenseDB.instance.queryDatabase();
                              }
                            }
                          } else {
                            int amount = int.parse(amountController.text == ""
                                ? "0"
                                : amountController.text);
                            ExpenseProvider().addExpense(
                                widget.id,
                                int.parse(expenseController.text),
                                amount,
                                widget.categoryname,
                                explantionController.text,
                                timeDate,
                                yearDate,
                                monthDate,
                                dayDate,
                                now.toString());
                            expenseController.text = "";
                            explantionController.text = "";
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Text(
                              "Gider eklendi.",
                              style: TextStyle(fontSize: 22),
                            )));
                            setState(() {
                              expenseList1 = [];
                              incomeList1 = [];
                            });
                            // ignore: use_build_context_synchronously
                            incomeList1 = await Provider.of<IncomeProvider>(
                                    context,
                                    listen: false)
                                .getIncome();
                            expenseList1 =
                                await ExpenseDB.instance.queryDatabase();
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Gider Ekle",
                      style: TextStyle(fontSize: 18, color: Colors.purple),
                    )),
              ),
            ])));
  }
}
