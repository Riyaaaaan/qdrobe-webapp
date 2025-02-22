import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qdrobe_app/screens/home.dart';
import 'package:qdrobe_app/screens/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: showHome ? const Home() : const IntroScreen(),
    );
  }
}
