import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/camera_save_img.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Code Snippets',
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new CamSaveImg(),
    );
  }
}