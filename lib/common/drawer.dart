import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../entity/user.dart';
import '../entity/editable_event.dart';
import '../entity/event.dart';
import '../common/event_card.dart';
import 'space_box.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: Column(children: [
          SpaceBox.height(50),
          FutureBuilder(
              future: _getUserId(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }

                return CreateEventCard(snapshot.hasData);
              }),
          SpaceBox.height(50),
          Text('共同編集中のイベント一覧',
              style: TextStyle(color: Colors.grey[900], fontSize: 16)),
          EditableEvents()
        ]));
  }

  CreateEventCard(bool hasData) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: ListTile(
                title: Text('新しいイベントを設定', style: TextStyle(fontSize: 16)),
                trailing: IconButton(
                    icon: Icon(Icons.create_rounded, color: Colors.indigo[300]),
                    onPressed: () {
                      if (hasData) {
                        /*
                Navigator.pushNamed(
                    context,
                    DetailEditorPage().routeName,

                    // ユーザー情報を渡す
                    arguments: user
                )
                */
                      } else {
                        /*
                Navigator.pushNamed(
                    context,
                    AuthPage().routeName,
                );
                 */
                      }
                    }))));
  }

  Future<String> _getUserId() async {
    final Future<Database> database =
        openDatabase(join(await getDatabasesPath(), 'onTime.db'));
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['userId'];
  }
}

class EditableEvents extends StatefulWidget {
  @override
  _EditableEventsState createState() => _EditableEventsState();
}

class _EditableEventsState extends State<EditableEvents> {
  @override
  Widget build(BuildContext context) {
    List<EditableEvent> editableEvents;

    return FutureBuilder(
        future: _getEditableEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: editableEvents.length,
                itemBuilder: (BuildContext context, int index) {
                  return EventCard(
                      event: Event(
                          editableEvents[index].id,
                          editableEvents[index].title,
                          editableEvents[index].date,
                          ''),
                      displayAll: false);
                });
          } else {
            return Container();
          }
        });
  }

  Future<List<EditableEvent>> _getEditableEvents() async {
    final Future<Database> database =
        openDatabase(join(await getDatabasesPath(), 'onTime.db'));
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('editableEvents');
    return List.generate(maps.length, (i) {
      return EditableEvent(
        id: maps[i]['id'],
        title: maps[i]['eventTitle'],
        date: maps[i]['eventDate'],
      );
    });
  }
}
