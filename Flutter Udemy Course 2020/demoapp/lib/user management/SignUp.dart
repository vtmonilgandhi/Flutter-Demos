import 'package:demoapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Dashboard.dart';
import '../utils/AppImagePicker.dart';
import '../utils/database_helper.dart';

class _SignUpData {
  String name = "";
  String password = "";
  String email = "";
  String city = "";
  String birthdate = "";
}

List _users;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isRemember = false;
  AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  _SignUpData _data = new _SignUpData();
  var db = new DatabaseHelper();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  save() async {
    _users = await db.getAllUsers();

    if (_formKey.currentState.validate()) {
      int savedUser = await db.saveUser(new User(_data.name, _data.password,
          _data.email, _data.birthdate, _data.city));
      print("User saved: $savedUser");
      if (isRemember) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name', _data.name);
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
      print("Login Successful");
      setState(() {
        _data.name = _data.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('Assets/image2.png'),
        fit: BoxFit.cover,
      )),
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.transparent,
        body: new Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [BoxShadow(color: Colors.blueAccent)]),
                    padding: EdgeInsets.all(24.0),
                    child: AppImagePicker()),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Username',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter name";
                            } else {
                              _data.name = value;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Email',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter email";
                            } else {
                              _data.email = value;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: TextFormField(
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Password',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter password";
                            } else {
                              _data.password = value;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: TextFormField(
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Confirm Password',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Birthdate',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter birthday";
                            } else {
                              _data.birthdate = value;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'City',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter city";
                            } else {
                              _data.city = value;
                              // Show Something
                              print("ALl is good");
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: MaterialButton(
                          onPressed: save,
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          color: Color(0xffff2d55),
                          elevation: 0,
                          minWidth: 350,
                          height: 60,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
