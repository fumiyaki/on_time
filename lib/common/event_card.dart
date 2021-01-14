import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../entity/event.dart';
import '../common/space_box.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final bool displayAll;
  EventCard({this.event, this.displayAll});

  @override
  _EventCardState createState() =>
      _EventCardState(event: event, displayAll: displayAll);
}

class _EventCardState extends State<EventCard> {
  Event event;
  bool displayAll;
  _EventCardState({this.event, this.displayAll});

  @override
  Widget build(BuildContext context) {
    DateTime eventDate = event.eventDate.toDate();
    final double numberSize = 20.0;
    final double letterSize = 10.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // イベント名
          Row(children: [
            SpaceBox.width(30),
            Expanded(
              child: ListTile(
                  title: Text(event.eventTitle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.grey[850])),

                  // 共有ボタン
                  trailing: Visibility(
                      visible: displayAll,
                      child: IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            Share.share(
                                "Link to open this particular event in OnTime App");
                          }))),
            )
          ]),

          // 開催日時
          Row(children: [
            SpaceBox.width(50),
            Text(
              eventDate.year.toString(),
              style: TextStyle(fontSize: numberSize, color: Colors.grey[800]),
            ),
            Text('年',
                style: TextStyle(fontSize: letterSize, color: Colors.grey[800]),

                // 異なる文字サイズを下揃えする
                strutStyle: StrutStyle(
                  fontSize: numberSize,
                )),
            Text(
              eventDate.month.toString(),
              style: TextStyle(fontSize: numberSize, color: Colors.grey[800]),
            ),
            Text('月',
                style: TextStyle(fontSize: letterSize, color: Colors.grey[800]),
                strutStyle: StrutStyle(
                  fontSize: numberSize,
                )),
            Text(
              eventDate.day.toString(),
              style: TextStyle(fontSize: numberSize, color: Colors.grey[800]),
            ),
            Text('日',
                style: TextStyle(fontSize: letterSize, color: Colors.grey[800]),
                strutStyle: StrutStyle(
                  fontSize: numberSize,
                )),
            SpaceBox.width(10),
            Text(
              eventDate.hour.toString().padLeft(2, "0") +
                  ':' +
                  eventDate.minute.toString().padLeft(2, "0"),
              style: TextStyle(fontSize: numberSize, color: Colors.grey[800]),
            ),
            Text('JST',
                style: TextStyle(fontSize: letterSize, color: Colors.grey[800]),
                strutStyle: StrutStyle(
                  fontSize: numberSize,
                )),
          ]),
          SpaceBox.height(10),

          Visibility(
              visible: displayAll,
              child: Column(children: [
                // イベント画像
                FutureBuilder(
                    future: getURL(event.id),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      // 画像URL取得中の表示
                      if (snapshot.connectionState != ConnectionState.done) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasData) {
                        return ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 150),
                            child: Image.network(snapshot.data));
                      } else {
                        // 画像取得エラー
                        return Container();
                      }
                    }),
                SpaceBox.height(10),

                // イベント詳細
                Row(children: [
                  SpaceBox.width(30),
                  Expanded(
                    child: Text(
                        event.eventDetails,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3, // 3行以上の説明文は省略表示
                        style: TextStyle(color: Colors.grey[700])),
                  ),
                  SpaceBox.width(30)
                ]),
                SpaceBox.height(5),

                // 詳細ボタン
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                        width: 60,
                        child: RaisedButton(
                          child: const Text('詳細'),
//                                        color: Colors.indigo[300],
                          color: Colors.blue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          onPressed: () {
                            /*
                                        // スケジュール画面への遷移
                                        Navigator.pushNamed(
                                          context,
                                          SchedulePage().routeName,
                                        // eventsコレクションのドキュメントIDを渡す
                                          arguments: events[index].reference.id
                                        );
                                        */
                          },
                        )),
                    SpaceBox.width(10)
                  ],
                ),
                SpaceBox.height(5)
              ]))
        ],
      ),
    );
  }

  // Cloud Storage URL取得
  Future<String> getURL(String documentID) async {
    final String downloadURL = await FirebaseStorage.instance
        .ref('event_images/' + documentID + '.png')
        .getDownloadURL();
    return downloadURL;
  }
}
