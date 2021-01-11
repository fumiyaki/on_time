import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:intl/intl.dart" as intl;
import 'package:flutter/gestures.dart';
import "../schedule/schedule.dart";

class EventCards extends StatefulWidget {
  @override
  _EventCardsState createState() => _EventCardsState();
}

class _EventCardsState extends State<EventCards> {
  String formatTimestamp(Timestamp timestamp) {
    initializeDateFormatting("ja_JP");
    DateTime dateTime = timestamp.toDate();
    var formatter = new intl.DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  Future<String> getURL(String documentID) async {
    final String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('event_images/' + documentID + '.png')
        .getDownloadURL();
    return downloadURL;
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
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('event_date',
                    isGreaterThan: DateTime.now().add(Duration(days: 1) * -1))
//                isGreaterThan: DateTime.now().add(Duration(days: 10)))
                .orderBy('event_date', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  List<DocumentSnapshot> events = snapshot.data.docs;
                  if (events.isEmpty) {
                    return Center(
                      child: Text('登録されたイベントがありません')
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) return Container();

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 50.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(children: [
                              SpaceBox.width(30),
                              Expanded(
                                  child: ListTile(
                                      title: Text(
                                          events[index - 1]["event_title"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      subtitle: Text(formatTimestamp(
                                          events[index - 1]["event_date"])),
                                      trailing: IconButton(
                                          icon: Icon(Icons.share),
                                          onPressed: () {
                                            Share.share(
                                                "Link to open this particular event in OnTime App");
                                          }))),
                            ]),
                            FutureBuilder(
                                future: getURL(events[index - 1].reference.id),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState !=
                                      ConnectionState.done) {
                                    return CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  }
                                  if (snapshot.hasData) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: 150),
                                      child: Image.network(snapshot.data)
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                              ListTile(
                                  subtitle: Text(events[index - 1]["event_details"],
                                  overflow: TextOverflow.ellipsis, maxLines: 3),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                    width: 60,
                                    child: RaisedButton(
                                      child: const Text('詳細'),
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      onPressed: () {
                                        /*
                                    Navigator.pushNamed(
                                      context,
                                      SchedulePage().routeName,
                                      arguments: events[index - 1].reference.id
                                    );
                                    */
                                      },
                                    )),
                                SpaceBox.width(10)
                              ],
                            ),
                          ],
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
        return CircularProgressIndicator();
      },
    );
  }
}

class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}
