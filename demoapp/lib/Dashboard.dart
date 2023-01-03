import 'package:demoapp/main%20screen/Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('name');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext ctx) => Home()));
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
