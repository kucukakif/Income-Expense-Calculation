import 'dart:async';
import 'package:flutter/material.dart';
import 'package:salary_planning/screens/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialization();
    });
  }

  void initialization() async {
    Future.delayed(
        const Duration(milliseconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => MainPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.bottomLeft,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              transform: GradientRotation(18),
              colors: [
                Color.fromARGB(255, 80, 134, 141),
                Color.fromARGB(255, 221, 194, 144),
              ],
            )),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 150),
            child: const Text(
              "Daha iyi bir gelecek için harcamalarınızı planlayın.",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            )));
  }
}
