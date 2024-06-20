import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salary_planning/helpers/expense_db.dart';
import 'package:salary_planning/helpers/income_lowCategories_db.dart';
import 'package:salary_planning/helpers/past_years_db.dart';
import 'package:salary_planning/providers/expense_provider.dart';
import 'package:salary_planning/providers/income_lowCategories_provider.dart';
import 'package:salary_planning/providers/income_provider.dart';
import 'package:salary_planning/providers/past_years_provider.dart';
import 'package:salary_planning/screens/past_incpmes_and_expenses.dart';

import '../models/income_low_categoriy_model.dart';

class IncomeAddScreen extends StatefulWidget {
  final String categoryname;
  final int id;
  const IncomeAddScreen({required this.categoryname, required this.id});

  @override
  State<IncomeAddScreen> createState() => _IncomeAddScreenState();
}

class _IncomeAddScreenState extends State<IncomeAddScreen> {
  final incomeController = TextEditingController();
  final explantionController = TextEditingController();
  final lowerIncomeCategoryController = TextEditingController();
  final scaffoldState = GlobalKey<ScaffoldState>();
  Object lowCategoryName = "";
  String? kategoriEkle;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data();
      lowCategoryData();
    });
    print(dataList);
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

  String date = "";
  data() async {
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

  List<IncomeLowCategoriyModel> dataList = [];

  lowCategoryData() async {
    final data =
        await IncomeLowCategoryProvider().queryLowCategory(widget.categoryname);
    setState(() {
      dataList = data;
    });
    dataList.add(IncomeLowCategoriyModel(
        categoryname: widget.categoryname, lowCategoryName: "Kategori Ekle"));
    setState(() {
      lowCategoryName = "Kategori Ekle";
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          Container(
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
                            if (dataList[i].lowCategoryName == kategoriEkle) {
                              scaffoldState.currentState!.showBottomSheet(
                                  (ctx) => Container(
                                        width: double.infinity,
                                        height: height * 0.4,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Alt Kategori İsmi :",
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  width: width * 0.03,
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    width: width * 0.50,
                                                    child: TextField(
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black),
                                                      controller:
                                                          lowerIncomeCategoryController,
                                                      decoration:
                                                          const InputDecoration
                                                              .collapsed(
                                                        hintText:
                                                            "Alt Kategori İsmini Giriniz",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    134,
                                                                    141),
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * 0.15,
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  if (lowerIncomeCategoryController
                                                      .text.isEmpty) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Hata"),
                                                            content: const Text(
                                                                "Alt kategori ismi boş!"),
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
                                                    await IncomeLowCategoriesDB
                                                        .instance
                                                        .insert({
                                                      IncomeLowCategoriesDB
                                                              .columnCategoryname:
                                                          widget.categoryname,
                                                      IncomeLowCategoriesDB
                                                              .columnLowCategoryName:
                                                          lowerIncomeCategoryController
                                                              .text
                                                    });
                                                    Navigator.pop(context);
                                                    lowerIncomeCategoryController
                                                        .text = "";
                                                    final data =
                                                        await IncomeLowCategoryProvider()
                                                            .queryLowCategory(
                                                                widget
                                                                    .categoryname);
                                                    setState(() {
                                                      dataList = data;
                                                      lowCategoryName = dataList
                                                          .first
                                                          .lowCategoryName;
                                                    });
                                                    dataList.add(
                                                        IncomeLowCategoriyModel(
                                                            categoryname: widget
                                                                .categoryname,
                                                            lowCategoryName:
                                                                "Kategori Ekle"));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                      "Alt Kategori eklendi.",
                                                      style: TextStyle(
                                                          fontSize: 22),
                                                    )));
                                                  }
                                                },
                                                child: const Text(
                                                  "Alt Kategori Ekle",
                                                  style: TextStyle(
                                                      color: Colors.purple,
                                                      fontSize: 20),
                                                ))
                                          ],
                                        ),
                                      ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 221, 194, 144));
                            }
                          },
                        ),
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.07,
            ),
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9\.]"))
                    ],
                    controller: incomeController,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Gelir Tutarı",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 19),
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
            padding: EdgeInsets.only(
              left: width * 0.07,
            ),
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
                  width: width * 0.7,
                  child: TextField(
                    controller: explantionController,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Açıklama",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 19),
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
                  String monthDate = DateFormat.LLLL().format(DateTime.now());
                  String dayDate = DateFormat.MMMMd().format(DateTime.now());
                  DateTime now = DateTime.now();

                  if (incomeController.text.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text("Hata"),
                            content: const Text("Gelir girmelisin!"),
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
                    final incomeData = await IncomeProvider().getIncome();
                    final expenseData =
                        await ExpenseDB.instance.queryDatabase();
                    for (int i = 0; i < incomeData.length; i++) {
                      if (incomeData[i].yearDate != yearDate) {
                        await PastYearsProvider().addPastYear(
                            incomeData.toString(), expenseData.toString());
                        await IncomeProvider().deleteIncome(incomeData[i], i);
                      }
                    }
                    for (int i = 0; i < expenseData.length; i++) {
                      if (expenseData[i].yearDate != yearDate) {
                        await ExpenseProvider()
                            .deleteExpense(expenseData[i], i);
                      }
                    }
                    IncomeProvider().addIncome(
                        int.parse(incomeController.text),
                        lowCategoryName != "Kategori Ekle"
                            ? lowCategoryName.toString()
                            : widget.categoryname,
                        explantionController.text,
                        timeDate,
                        yearDate,
                        monthDate,
                        dayDate,
                        now.toString());
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      "Gelir eklendi.",
                      style: TextStyle(fontSize: 22),
                    )));
                    setState(() {
                      expenseList1 = [];
                      incomeList1 = [];
                    });
                    incomeList1 = await Provider.of<IncomeProvider>(context,
                            listen: false)
                        .getIncome();
                    expenseList1 = await ExpenseDB.instance.queryDatabase();
                  }
                },
                child: const Text(
                  "Gelir Ekle",
                  style: TextStyle(fontSize: 22, color: Colors.purple),
                )),
          ),
        ]),
      ),
    );
  }
}
