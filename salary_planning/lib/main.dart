import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salary_planning/providers/expense_lowCategory_provider.dart';
import 'package:salary_planning/providers/expense_provider.dart';
import 'package:salary_planning/providers/income_lowCategories_provider.dart';
import 'package:salary_planning/providers/income_provider.dart';
import 'package:salary_planning/screens/main_page.dart';
import 'package:salary_planning/screens/splash_screen.dart';
import 'providers/expense_category_provider.dart';
import 'providers/income-category_provider.dart';

void main() async {
  // runApp(DevicePreview(
  //     enabled: !kReleaseMode, builder: (context) => const MyApp()));
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => IncomeProvider()),
        ChangeNotifierProvider(create: (context) => ExpenseCategoryProvider()),
        ChangeNotifierProvider(create: (context) => IncomeCategoryProvider()),
        ChangeNotifierProvider(
            create: (context) => ExpenseLowCategoryProvider()),
        ChangeNotifierProvider(
            create: (context) => IncomeLowCategoryProvider()),
      ],
      child: MaterialApp(
        // ignore: deprecated_member_use
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const SplashScreen(),
        routes: {
          MainPage.routeName: (context) => const MainPage(),
          MainPageBody.routeName: (context) => const MainPageBody(),
        },
      ),
    );
  }
}
