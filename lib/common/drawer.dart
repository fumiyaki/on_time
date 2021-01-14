import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

          // ログイン済みかどうかを判断
          FutureBuilder(
              future: _getUserId(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }

                return getCreateEventCard(snapshot.hasData);
              }),

          SpaceBox.height(50),
          Text('共同編集中のイベント一覧',
              style: TextStyle(color: Colors.grey[900], fontSize: 16)),

          // 共同編集中のイベント一覧
          EditableEvents()
        ]));
  }

  //
  Card getCreateEventCard(bool hasData) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: ListTile(
                title: Text('新しいイベントを設定', style: TextStyle(fontSize: 16)),

                // 鉛筆ボタン
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

  // ログイン中かどうかを判定
  Future<String> _getUserId() async {
    final Future<Database> database =
        openDatabase(join(await getDatabasesPath(), 'onTime.db'));
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['userId'];
  }
}

// 共同編集中のイベント一覧
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
            print('hasData');
            editableEvents = snapshot.data;
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                itemCount: editableEvents.length,
                itemBuilder: (BuildContext context, int index) {
                  return EventCard(
                      event: Event(
                          editableEvents[index].id,
                          editableEvents[index].title,
                          editableEvents[index].date,
                          ''),
                      displayAll: false);
                },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),)
            );
          } else {
            print('no data');
            return Container();
          }
        });
  }

  Future<List<EditableEvent>> _getEditableEvents() async {
    List<EditableEvent> eventList = new List<EditableEvent>();
    EditableEvent event = new EditableEvent(
        id: 'abcde', title: 'タイトル', date: Timestamp.fromDate(DateTime.now())
    );
    eventList.add(event);
    return eventList;

    final Future<Database> database =
        openDatabase(join(await getDatabasesPath(), 'onTime.db'));
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('editableEvents');


    /*
    return List.generate(maps.length, (i) {
      return EditableEvent(
        id: maps[i]['id'],
        title: maps[i]['eventTitle'],
        date: maps[i]['eventDate'],
      );
    });
     */
  }
}
