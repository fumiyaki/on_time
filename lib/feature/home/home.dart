import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class EventCards extends StatelessWidget {
  String formatTimestamp(Timestamp timestamp) {
    initializeDateFormatting("ja_JP");
    DateTime dateTime = timestamp.toDate();
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // エラー時に表示するWidget
        if (snapshot.hasError) {
          return Container(color: Colors.white);
        }

        // Firebaseのinitialize完了したら表示したいWidget
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('events').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  List<DocumentSnapshot> events = snapshot.data.docs;
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) return Container();
                      return Center(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(events[index - 1]["event_title"]),
                                subtitle: Text(formatTimestamp(events[index - 1]["event_date"])),
                              ),
                              Image.network('https://hakuhin.jp/graphic/title.png'),
                              ListTile(
                                subtitle: Text(events[index - 1]["event_details"]),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('JOIN'),
                                    onPressed: () {
                                      /* ... */
                                    },
                                  ),
                                  const SizedBox(width: 8)
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: events.length + 1,
                  );
              }
            },
          );
        }

        // Firebaseのinitializeが完了するのを待つ間に表示するWidget
        return Text('Loading...');
      },
    );
  }
}