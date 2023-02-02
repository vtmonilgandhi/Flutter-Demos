import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _quakes;
List _features;

void main() async {
  _quakes = await getQuakes();
  _features = _quakes['features'];

  runApp(new MaterialApp(title: "Quakes", home: new Quakes()));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Quakes"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, int position) {
              if (position.isOdd) return new Divider();
              final index = position ~/ 2;
              var format = new DateFormat.yMMMMd("en_US").add_jm();
              var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(
                  _features[index]['properties']['time'] * 1000,
                  isUtc: true));
              return new ListTile(
                title: new Text("At: $date",
                    style: new TextStyle(
                        fontSize: 15.5,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500)),
                subtitle: new Text("${_features[index]['properties']['place']}",
                    style: new TextStyle(
                        fontSize: 14.5,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal)),
                leading: new CircleAvatar(
                  backgroundColor: Colors.green,
                  child: new Text("${_features[index]['properties']['mag']}",
                      style: new TextStyle(
                          fontSize: 16.5,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold)),
                ),

                onTap: () {_showAlertMessage(context,"${_features[index]['properties']['title']}");},
              );
            }),
      ),
    );
  }
}

void _showAlertMessage(BuildContext context, String message) {
  var alertDialog = new AlertDialog(
    title: new Text('Quakes'),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("OK"),
      )
    ],
  );

  showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      });
}

Future<Map> getQuakes() async {
  String apiUrl =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}
