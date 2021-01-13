import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/user.dart';
import '../entity/event.dart';
import '../common/event_card.dart';
import 'space_box.dart';

class MyDrawer extends StatefulWidget {
  final User user;

  MyDrawer({this.user});

  @override
  _MyDrawerState createState() => _MyDrawerState(user: this.user);
}

class _MyDrawerState extends State<MyDrawer> {
  User user;
  List<Event> events;

  _MyDrawerState({this.user, this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: Column(children: [
          SpaceBox.height(50),
          Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: ListTile(
                      title: Text('新しいイベントを設定', style: TextStyle(fontSize: 16)),
                      trailing: IconButton(
                          icon: Icon(Icons.create_rounded,
                              color: Colors.indigo[300]),
                          onPressed: () {
                            if (user.id == null) {
                              /*
                Navigator.pushNamed(
                    context,
                    AuthPage().routeName,
                );

                 */
                            } else {
                              /*
                Navigator.pushNamed(
                    context,
                    DetailEditorPage().routeName,

                    // ユーザー情報を渡す
                    arguments: user
                )
                */
                            }
                          })))),
          SpaceBox.height(50),
          Text('共同編集中のイベント一覧',
              style: TextStyle(color: Colors.grey[900], fontSize: 16)),
          EditableEvents(user: user, events: events)
        ]));
  }
}

class EditableEvents extends StatefulWidget {
  User user;
  List<Event> events;
  EditableEvents({this.user, this.events});

  @override
  _EditableEventsState createState() =>
      _EditableEventsState(user: user, events: events);
}

class _EditableEventsState extends State<EditableEvents> {
  User user;
  List<Event> events;

  _EditableEventsState({this.user, this.events});

  @override
  Widget build(BuildContext context) {
    List<Event> editableEvents;
    if (events != null) {
      for (Event event in events) {
        for (String editableEventId in user.editableEvents) {
          if (event.id == editableEventId) {
            editableEvents.add(event);
          }
        }
      }
    }

    // 表示すべきイベントがない場合
    if (editableEvents == null || editableEvents.isEmpty) {
//                      return Center(child: Text('共同編集可能なイベントはありません'));
      return Container();
    }

    // 表示すべきイベントがある場合
    return ListView.builder(
        itemCount: editableEvents.length,
        itemBuilder: (BuildContext context, int index) {
          return EventCard(event: editableEvents[index], displayAll: false);
        });
  }
}
