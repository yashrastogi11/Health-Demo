import 'package:flutter/material.dart';
import 'package:health/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      title: "Health App",
      theme: ThemeData(
        // buttonColor: Color.fromARGB(255, 14, 190, 223),
        backgroundColor: Color.fromARGB(255, 245, 243, 240),
        // accentColor: Color.fromARGB(255, 191, 213, 201),
        primarySwatch: Colors.lightGreen,
      ),
    );
  }
}
