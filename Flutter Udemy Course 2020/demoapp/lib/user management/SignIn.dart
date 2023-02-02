import 'package:demoapp/Dashboard.dart';
import 'package:demoapp/user%20management/OTPScreen.dart';
import 'package:demoapp/user%20management/SignUp.dart';
import 'package:demoapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/database_helper.dart';

class _LoginData {
  String name = "";
  String password = "";
}

List _users;

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isRemember = false;
  final _formKey = GlobalKey<FormState>();
  _LoginData _data = new _LoginData();
  var db = new DatabaseHelper();

  save() async {
    _users = await db.getAllUsers();

    if (_formKey.currentState.validate()) {
      for (int i = 0; i < _users.length; i++) {
        User user = User.map(_users[i]);
        if (user.username == _data.name && user.password == _data.password) {
          if (isRemember) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('name', _data.name);
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
          print("Login Successful");
        }
      }
      setState(() {
        _data.name = _data.name;
      });
//      Scaffold.of(context).showSnackBar(SnackBar(content: Text("All is good")));
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                      TextFormField(
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
                            // Show Something
                            _data.password = value;
                          }
                        },
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 5),
                        child: Checkbox(
                          value: isRemember,
                          checkColor: Colors.white,
                          activeColor: Colors.red,
                          onChanged: (bool value) {
                            setState(() {
                              isRemember = value;
                            });
                          },
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 5),
                      child: Text(
                        'Remember Me',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: 'SFUIDisplay',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(32)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OTPScreen()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 5),
                        child: Text(
                          'Forgot your password?',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'SFUIDisplay',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: save,
                    child: Text(
                      'SIGN IN',
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                    print("Signup Clicked");
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                color: Colors.white,
                                fontSize: 15,
                              )),
                          TextSpan(
                              text: "sign up",
                              style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                color: Color(0xffff2d55),
                                fontSize: 15,
                              ))
                        ]),
                      ),
                    ),
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
