import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _ageController = new TextEditingController();
  final TextEditingController _heightController = new TextEditingController();
  final TextEditingController _weightController = new TextEditingController();
  double inches = 0.0;
  double result = 0.0;
  String _resultReading = "";
  String _finalResult = "";

  void calculateBMI() {
    setState(() {
      int age = int.parse(_ageController.text);
      double height = double.parse(_heightController.text);
      inches = height * 12;
      double weight = double.parse(_weightController.text);

      if ((_ageController.text.isNotEmpty || age > 0) &&
          (_heightController.text.isNotEmpty || inches > 0) &&
          (_weightController.text.isNotEmpty || weight > 0)) {
        result = weight / (inches * inches) * 703; // Our BMI

        if (double.parse(result.toStringAsFixed(1)) < 18.5) {
          _resultReading = "Underweight";
        } else if (double.parse(result.toStringAsFixed(1)) >= 18.5 &&
            result < 25) {
          _resultReading = "Great Shape";
        } else if (double.parse(result.toStringAsFixed(1)) >= 25.0 &&
            result < 30) {
          _resultReading = "Overweight";
        } else if (double.parse(result.toStringAsFixed(1)) >= 30) {
          _resultReading = "Obese";
        } else {
          _resultReading = "";
        }
      } else {
        result = 0.0;
      }
    });

    _finalResult = "Your BMI: ${result.toStringAsFixed(1)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("BMI"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: new Container(
        alignment: Alignment.topCenter,
        child: new ListView(
          padding: const EdgeInsets.all(2.0),
          children: <Widget>[
            new Image.asset("images/bmilogo.png", height: 85.0, width: 75.0),
            new Container(
              margin: new EdgeInsets.all(3.0),
              width: 290.0,
              color: Colors.grey.shade300,
              child: new Column(
                children: <Widget>[
                  new TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          labelText: "Age",
                          hintText: "e.g: 34",
                          icon: new Icon(Icons.person_outline))),
                  new TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          labelText: "height in feet",
                          hintText: "e.g: 6.5",
                          icon: new Icon(Icons.insert_chart))),
                  new TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          hintText: "e.g: 180",
                          labelText: "Weight in lb",
                          icon: new Icon(Icons.menu))),
                  new Padding(padding: new EdgeInsets.all(10.6)),
                  new Container(
                    alignment: Alignment.center,
                    child: new RaisedButton(
                        onPressed: calculateBMI,
                        color: Colors.pinkAccent,
                        child: new Text("Calculate"),
                        textColor: Colors.white),
                  )
                ],
              ),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("$_finalResult",
                    style: new TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 19.9)),
                new Padding(padding: new EdgeInsets.all(5.0)),
                new Text("$_resultReading",
                    style: new TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 19.9))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
