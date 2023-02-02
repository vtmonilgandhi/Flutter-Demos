import 'package:flutter/material.dart';
import 'package:gesture_detector/ui/home.dart';

void main() {
  var title = "Gestures";
  runApp(new MaterialApp(
    title: title,
    home: new Home(title: title),
  ));
}
