import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../common/app_bar.dart';
import '../../common/drawer.dart';
import '../../entity/argument.dart';
import '../../entity/event.dart';

class DragIntoListExample extends StatefulWidget {
  DragIntoListExample({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DragIntoListExample createState() => _DragIntoListExample();
}

class _DragIntoListExample extends State<DragIntoListExample> {
  List<DragAndDropList> _contents = List<DragAndDropList>();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final EventList = TextEditingController();
  final EventTask = TextEditingController();
  String SessionTime = '1';
  String ItemTime ='1';
  Argument argument;

  @override
  Widget build(BuildContext context) {
    Argument argument = ModalRoute.of(context).settings.arguments;

    /// temporary
    Event event = new Event(eventTitle: 'タイトル', viewerURL: Uri.parse('https://appontime.page.link/H3Ed'), editorURL: Uri.parse('https://appontime.page.link/4R89'));
    argument = new Argument(event: event);
    var backgroundColor = Color.fromARGB(255, 243, 242, 248);
    double screenWidth = MediaQuery.of(context).size.width;

    CollectionReference addcontents = FirebaseFirestore.instance.collection(
        'timetable');

    Future<void> addContents() {
      // Call the user's CollectionReference to add a new user
      return addcontents
          .add({
        //'event_list': EventList.text,
        //'event_task': EventTask.text,
        'event_list': EventList.text,
        'event_task': EventTask.text,
        'session_time':SessionTime,
        'item_time':ItemTime,
      })
          .then((value) => print("Contents Added"))
          .catchError((error) => print("Failed to add event: $error"));
    }

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      EventList.dispose();
      EventTask.dispose();
      super.dispose();
    }

    return Scaffold(
        appBar: MyAppBar(_key),
        body: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                    padding: EdgeInsets.all(25.0),
                    child:Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                                children:<Widget>[
                                  Center(
                                    child:
                                    new Text(argument.event.eventTitle,
                                      style: new TextStyle(fontSize:30.0,
                                          color: const Color(0xFF000000),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Roboto"),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          Container(padding: EdgeInsets.only(top:20,bottom:0),
                            child: Row(
                                children:<Widget>[
                                  //SpaceBox.width(30),
                                  Center(
                                    child:
                                    new Text(
                                      "一般公開用URL",
                                      style: new TextStyle(fontSize:18.0,
                                          color: const Color(0xFF000000),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Roboto"),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:5),
                            child: Row(
                                children:<Widget>[
                                  //SpaceBox.width(30),
                                  Column(
                                      children:<Widget>[
                                        Text(argument.event.viewerURL.toString(),
                                          style: new TextStyle(fontSize:18.0,
                                              color: const Color(0xFF000000),
                                              fontWeight: FontWeight.w200,
                                              decoration: TextDecoration.underline,
                                              decorationColor: Colors.black,
                                              fontFamily: "Roboto"),
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    iconSize: 20,
                                    onPressed: () {},
                                  ),
                                ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:20,bottom:0),
                            child:Row(
                                children:<Widget>[
                                  //SpaceBox.width(30),
                                  new Text(
                                    "共同編集用URL",
                                    style: new TextStyle(fontSize:18.0,
                                        color: const Color(0xFF000000),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Roboto"),
                                  ),
                                  new Text(
                                    "(ontimeチャットで共有禁止)",
                                    style: new TextStyle(fontSize:14.0,
                                        color: const Color(0xFF000000),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Roboto"),
                                  ),
                                ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:5),
                            child: Row(
                                children:<Widget>[
                                  //SpaceBox.width(30),
                                  Column(
                                      children:<Widget>[
                                        Text(argument.event.editorURL.toString(),
                                          style: new TextStyle(fontSize:18.0,
                                              color: const Color(0xFF000000),
                                              decoration: TextDecoration.underline,
                                              decorationColor: Colors.black,
                                              fontWeight: FontWeight.w200,
                                              fontFamily: "Roboto"),
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    iconSize: 20,
                                    onPressed: () {},
                                  ),
                                ]
                            ),
                          ),
//                  DragIntoListExample()
                          /*
                  Container(
                    padding: EdgeInsets.only(top:5),
                    child: _DeliveryProcesses(
                    processes: data.deliveryProcesses,
                        doing: data.complete,
                        startingdate: data.startdate,
                        nowtime: data.date),

                  ),
                   */
                        ]
                    )
                ),
              ),
              Flexible(
                flex: 10,
                child: DragAndDropLists(
                  children: _contents,
                  onItemReorder: _onItemReorder,
                  onListReorder: _onListReorder,
                  onItemAdd: _onItemAdd,
                  onListAdd: _onListAdd,
                  listGhost: Container(
                    height: 50,
                    width: 100,
                    child: Center(
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.blue,
                        child: Center(
                          child: Draggable<DragAndDropListInterface>(
                            feedback: Icon(Icons.assignment),
                            child: Icon(Icons.assignment, color: Colors.white,),
                            data: DragAndDropList(
                              //header: Text('New default list')
                              header: Column(
                                children: <Widget>[
                                  Card(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 400,
                                                height: 50,
                                                child: TextFormField(
                                                  controller: EventList,
                                                  decoration: const InputDecoration(
                                                    labelText: '演目',
                                                  ),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              DropdownButton<String>(
                                                value: SessionTime,
                                                hint: Text('分'),
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.blue,
                                                ),
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    SessionTime = newValue;
                                                  });
                                                },
                                                items: <String>[
                                                  '1','2','3','4','5'
                                                ].map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.blue,
                        child: Center(
                          child: Draggable<DragAndDropItem>(
                            feedback: Icon(Icons.photo),
                            child: Icon(Icons.photo, color: Colors.white,),
                            data: DragAndDropItem(
                              //child: Text('New default item')
                              child: Column(
                                children: <Widget>[
                                  Card(
                                      color: Colors.blue[50],
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 400,
                                                height: 50,
                                                child: TextFormField(
                                                  controller: EventList,
                                                  decoration: const InputDecoration(
                                                    labelText: 'タスク',
                                                  ),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              DropdownButton<String>(
                                                value: ItemTime,
                                                hint: Text('分'),
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.blue,
                                                ),
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    ItemTime = newValue;
                                                  });
                                                },
                                                items: <String>[
                                                  '1','2','3','4','5'
                                                ].map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
          floatingActionButton: Container(
              margin:EdgeInsets.only(bottom: 55.0),
              child: FloatingActionButton(
                onPressed: (){
                  addContents();
                  Navigator.pop(context);
                },
                child: Icon(Icons.save, color: Colors.white,),
                backgroundColor: Colors.blue,
              )),
          /// ドロワー
          drawerEdgeDragWidth: 0,
          drawer: SizedBox(
              width: 0.8 * screenWidth, child: MyDrawer(login: true)),
          key: _key,
        ));
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
      int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }

  _onItemAdd(DragAndDropItem newItem, int listIndex, int itemIndex) {
    print('adding new item');
    setState(() {
      if (itemIndex == -1)
        _contents[listIndex].children.add(newItem);
      else
        _contents[listIndex].children.insert(itemIndex, newItem);
    });
  }

  _onListAdd(DragAndDropListInterface newList, int listIndex) {
    print('adding new list');
    setState(() {
      if (listIndex == -1)
        _contents.add(newList);
      else
        _contents.insert(listIndex, newList);
    });
  }
}
