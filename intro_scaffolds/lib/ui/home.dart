import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  void _onPress() {
    print("Search Tapped!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.greenAccent.shade700,
        title: new Text("Fancey Day"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.send),
              onPressed: () => debugPrint("Icon Tapped!")),
          new IconButton(icon: new Icon(Icons.search), onPressed: _onPress)
        ],
      ),

      // Other Properties
      backgroundColor: Colors.grey.shade100,
      body: new Container(
        alignment: Alignment.center,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Hello ",
              style: new TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.deepOrange),
            ),
            new InkWell(
              child: new Text("Button!"),
              onTap: () => debugPrint("Button Tapped!"),
            ),
          ],
        ),
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: () => debugPrint("Pressed!"),
        backgroundColor: Colors.lightGreen,
        tooltip: 'Going Up!',
        child: new Icon(Icons.call_missed),
      ),

      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.add), title: new Text("Hey")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.print), title: new Text("nope")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.call_missed), title: new Text("Hello"))
        ],
        onTap: (int i) => debugPrint("Hey Touched $i"),
      ),
    );
  }
}
