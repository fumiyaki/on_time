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


class DragIntoListExample extends StatefulWidget {
  DragIntoListExample({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DragIntoListExample createState() => _DragIntoListExample();
}

class _DragIntoListExample extends State<DragIntoListExample> {
  List<DragAndDropList> _contents = List<DragAndDropList>();

  final EventList = TextEditingController();
  final EventTask = TextEditingController();

    @override
    Widget build(BuildContext context) {
      var backgroundColor = Color.fromARGB(255, 243, 242, 248);

      return Scaffold(
        appBar: AppBar(
          title: Text('Drag Into List'),
        ),
        body: Column(
          children: <Widget>[
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
                                ListTile(
                                  tileColor: Colors.white,
                                  title: Text(
                                    'Header',
                                  ),
                                  subtitle: Text('test'),
                                ),
                                Divider(),
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
                                ListTile(
                                  tileColor: Colors.blue[50],
                                  title: Text('task'),
                                  subtitle: Text('test'),
                                ),
                                Divider(),
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
      );
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