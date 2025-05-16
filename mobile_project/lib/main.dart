import 'package:flutter/material.dart';
import 'package:mobile_project/screens/product_list_screen.dart';
import 'package:mobile_project/screens/signup_screen.dart';
import 'screens/store_list_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_search_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stores App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SignupScreen(),
    );
  }
}

