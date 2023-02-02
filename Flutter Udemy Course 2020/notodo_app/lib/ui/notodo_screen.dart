import 'package:flutter/material.dart';
import 'package:notodo_app/models/nodo_items.dart';
import 'package:notodo_app/utils/database_client.dart';
import 'package:notodo_app/utils/date_formatter.dart';

class NoToDoScreen extends StatefulWidget {
  @override
  _NoToDoScreenState createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  var db = new DatabaseHelper();
  final List<NoDoItem> _itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();
    _readNoDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _itemList.length,
                  itemBuilder: (_, int index) {
                    return new Card(
                      color: Colors.white10,
                      child: new ListTile(
                        title: _itemList[index],
                        onLongPress: () => _updateItem(_itemList[index], index),
                        trailing: new Listener(
                          key: new Key(_itemList[index].itemName),
                          child: new Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                          ),
                          onPointerDown: (pointerEvent) =>
                              _deleteNoDo(_itemList[index].id, index),
                        ),
                      ),
                    );
                  })),
          new Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _showFromDialog),
    );
  }

  void _showFromDialog() {
    var alert = new AlertDialog(
      content: Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't by stuff",
                icon: new Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    NoDoItem noDoItem =
        new NoDoItem(text, dateFormatted());
    int saveItemId = await db.saveItem(noDoItem);
    print("Itme saved id: $saveItemId");

    NoDoItem addedItem = await db.getItem(saveItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });
  }

  void _handleSubmittedUpdate(int index, NoDoItem item) async {
    _textEditingController.clear();
    setState(() {
     _itemList.removeWhere((element) {
       _itemList[index].itemName == item.itemName;
     });
    });
  }

  _readNoDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      setState(() {
        _itemList.add(NoDoItem.map(item));
      });
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted Item!");
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(NoDoItem item, int index) {
    var alert = new AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't by stuff",
                icon: new Icon(Icons.update)),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              NoDoItem newItemUpdated = NoDoItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": dateFormatted(),
                "id": item.id
              });
              _handleSubmittedUpdate(index, item);
              await db.updateItem(newItemUpdated);
              setState(() {
                _readNoDoList();
              });
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Update")),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}
