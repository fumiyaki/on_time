import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

<<<<<<< ours
import 'package:share/share.dart';
=======
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:intl/intl.dart";

class EventCards extends StatefulWidget {
  @override
  _EventCardsState createState() => _EventCardsState();
}
>>>>>>> theirs

class _EventCardsState extends State<EventCards> {
  String formatTimestamp(Timestamp timestamp) {
    initializeDateFormatting("ja_JP");
    DateTime dateTime = timestamp.toDate();
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  Future<String> getURL(String documentID) async {
<<<<<<< ours
    String downloadURL = '';
    try {
      downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('event_images/' + documentID + '.png')
          .getDownloadURL();
    } catch (error) {
      return Future.error(error);
    }
=======
    final String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('event_images/' + documentID + '.png')
        .getDownloadURL();
>>>>>>> theirs
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
        Image images_output;
        Image _images_output;
        // Firebaseのinitialize完了したら表示したいWidget
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('event_date',
                    isGreaterThan: DateTime.now().add(Duration(days: 1) * -1))
                .orderBy('event_date', descending: false)
                .snapshots(),
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
<<<<<<< ours
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
                                    return Image.network(snapshot.data);
                                  } else {
                                    return Text("Loading...");
                                  }
                                }),
                            ListTile(
                              subtitle: Text(events[index - 1]["event_details"],
                                  overflow: TextOverflow.ellipsis, maxLines: 3),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('JOIN'),
                                  onPressed: () {
                                    /* ... */
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      );
=======

                      getURL(events[index - 1].reference.id).then((content) {
                        return Image.network(content);
                      });
                      //   print("これがりんくでございやす" + url);
                      return Center(
                          child: Card(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(events[index - 1]["event_title"]),
                                subtitle: Text(formatTimestamp(
                                    events[index - 1]["event_date"])),
                              ),
                              //     Image.network(url),
                              FutureBuilder<String>(
                                  future: getURL(events[index - 1].reference.id)
                                      .then((content) {
                                    images_output = Image.network(content);
                                    return "A";
                                  }),
                                  builder: (context, snapshot) {
                                    List<Widget> children;
                                    if (snapshot.hasData) {
                                      children = <Widget>[images_output];
                                    } else {
                                      children = <Widget>[Container()];
                                    }
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: children,
                                      ),
                                    );
                                  }),
                            ]),
                      ));
>>>>>>> theirs
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
<<<<<<< ours

class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}
=======
>>>>>>> theirs
