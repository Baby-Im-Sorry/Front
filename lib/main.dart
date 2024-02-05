import 'package:bis_front/home.dart';
import 'package:flutter/material.dart';
import 'package:bis_front/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIS',
      locale: const Locale('ko', 'KR'),
      home: LoginScreen()
      // home: HomeScreen(username: "test1"),
    );
  }
}