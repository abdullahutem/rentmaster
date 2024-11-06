import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/view/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale('ar'),
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      getPages: [
        GetPage(name: '/welcome', page: () => WelcomeScreen()),
      ],
    );
  }
}