import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../entity/editable_event.dart';
import '../entity/my_user.dart';
import '../entity/event.dart';
import '../entity/argument.dart';
import '../common/event_card.dart';
import 'space_box.dart';

class MyDrawer extends StatefulWidget {
  bool login;
  MyDrawer({this.login});
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
          CreateEventCard(widget.login),
/*
          FutureBuilder(
              future: _getUserId(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }
                return CreateEventCard(true);
//                return CreateEventCard(snapshot.hasData);
              }),
*/
          SpaceBox.height(50),
          Text('共同編集中のイベント一覧',
              style: TextStyle(color: Colors.grey[900], fontSize: 16)),

          // 共同編集中のイベント一覧
          EditableEvents(),
          FlatButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut();
//                Navigator.pushNamed(context, '/auth');
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            icon: Icon(Icons.exit_to_app),
            label: Text('Logout'),
          )
        ]));
  }
}

//
class CreateEventCard extends StatelessWidget {
  final bool hasData;
  CreateEventCard(this.hasData);

  @override
  Widget build(BuildContext context) {
    String userId;
    /*
    if (hasData) {
        userId = FutureBuilder(
          future: getUserId(),
          builder: (BuildContext context,
              AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else {
              return null;
            }
          });
    }

     */

    MyUser user = new MyUser(id: userId);
//    Argument argument = new Argument(MyUser: user);
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: ListTile(
                title: Text('新しいイベントを設定', style: TextStyle(fontSize: 16)),

                /// 鉛筆ボタン
                trailing: IconButton(
                    icon: Icon(Icons.create_rounded, color: Colors.indigo[300]),
                    onPressed: () {
                      Argument argument = new Argument(nextPage: '/setup');
                      if (hasData) {
                        Navigator.pushNamed(context, '/setup', arguments: argument);
                      } else {
                        Navigator.pushNamed(context, '/auth', arguments: argument);
                      }
                    }))));
  }

  /// ユーザーIDを取得
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
            editableEvents = snapshot.data;
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: editableEvents.length,
                  itemBuilder: (BuildContext context, int index) {
//                    print(editableEvents[index].title);
                    return GestureDetector(
                        child: EventCard(
                        event: Event(
                            id: editableEvents[index].id,
                            eventTitle: editableEvents[index].title,
                            eventDate: editableEvents[index].date,
                            eventDetails: ''),
                        displayAll: false),
                    onTap: () {
                          Navigator.pushNamed(context, '/detail');
                    });
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ));
          } else {
            return Container();
          }
        });
  }

  Future<List<EditableEvent>> _getEditableEvents() async {
    List<EditableEvent> eventList = new List<EditableEvent>();

    /// テスト用の暫定コード　ここから
    EditableEvent event = new EditableEvent(
        id: 'abcde', title: 'タイトル', date: Timestamp.fromDate(DateTime.now()));
    eventList.add(event);
    return eventList;

    /// ここまで
/*
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
     */
  }
}
