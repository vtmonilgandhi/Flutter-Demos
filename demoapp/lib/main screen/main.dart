import 'package:demoapp/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String name;

  @override
  void initState() {
    super.initState();
    checkPref();
  }

  checkPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: name == null ? Home() : Dashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
