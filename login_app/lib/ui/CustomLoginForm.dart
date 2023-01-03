import 'package:flutter/material.dart';
import 'package:login_app/main.dart';

class CustomLoginForm extends StatefulWidget {
  @override
  _CustomLoginFormState createState() => _CustomLoginFormState();
}

//Data Class

class _LoginData {
  String name = "";
  String password = "";
}

class _CustomLoginFormState extends State<CustomLoginForm> {
  final _formKey = GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Add Image
          Center(
            child: Image.asset("images/face.png",
                width: 90, height: 90, color: Colors.white),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(3.3))),
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter name";
                } else {
                  _data.name = value;
                  // Show Something
                  print("ALl is good");
                }
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(3.3))),

              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter password";
                } else {
                  // Show Something
                  _data.password = value;
                  print("All is good");
                }
              },
            ),
          ),

          // Add Buttons
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Add actual Buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _data.name = _data.name;
                        });
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("All is good")));
                      }
                    },
                    child: Text("Submit"),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // clear everything
                        _formKey.currentState.reset();
                        setState(() {
                          _data.name = "";
                        });
                      }
                    },
                    child: Text("Clear"),
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: _data.name.isEmpty
                    ? Text("")
                    : Text(
                        "Welcome ${_data.name}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0,
                            color: Colors.white),
                      )),
          )
        ],
      ),
    );
  }
}
