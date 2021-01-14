import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import "../auth/auth.dart";
import "../schedule/schedule.dart";
import "../../entity/event.dart";
import "../../common/app_bar.dart";
import "../../common/event_card.dart";
import "../../common/drawer.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    bool isConnecting = true;
    bool hasData = false;

    return FutureBuilder(
        future: _getUserId(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            isConnecting = false;
            if (snapshot.hasData) {
              hasData = true;
            }
          }
          isConnecting = false;
          hasData = true;
          return new MyScaffold(isConnecting, hasData);
        });
  }

  Future<String> _getUserId() async {
    final Future<Database> database =
        openDatabase(join(await getDatabasesPath(), 'onTime.db'));
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['userId'];
  }
}

class MyScaffold extends StatefulWidget {
  final bool isConnecting;
  final bool hasData;
  MyScaffold(this.isConnecting, this.hasData);

  @override
  _MyScaffoldState createState() {
    return _MyScaffoldState();
  }
}

class _MyScaffoldState extends State<MyScaffold> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
        appBar: MyAppBar(_key),
        body: Scaffold(
          body: SafeArea(
            child: EventCards(),
          ),
          floatingActionButton: widget.hasData
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                  child: new Icon(Icons.chat))
              : Container(
                  width: 0.7 * screenWidth,
                  child: FloatingActionButton.extended(
                      onPressed: () {
//            Navigator.pushNamed(context, AuthPage().routeName,
                      },
                      label: Text('ログイン'))),
          floatingActionButtonLocation:
              widget.hasData ? null : FloatingActionButtonLocation.centerDocked,
          drawerEdgeDragWidth: 0,
          drawer: SizedBox(width: 0.8 * screenWidth, child: MyDrawer()),
          key: _key,
        ));
  }
}

class EventCards extends StatefulWidget {
  @override
  _EventCardsState createState() => _EventCardsState();
}

class _EventCardsState extends State<EventCards> {
  List<DocumentSnapshot> events;

  @override
  Widget build(BuildContext context) {
    // Firebaseの初期化
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Firebaseの初期化エラー
        if (snapshot.hasError) {
          return Center(child: Text('エラーが発生しています'));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Firestoreからイベントリストを取得
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('events')

                // 過去（1日以上前）のイベントは表示しない
                .where('event_date',
                    isGreaterThan: DateTime.now().add(Duration(days: 1) * -1))
//                isGreaterThan: DateTime.now().add(Duration(days: 10)))
                .orderBy('event_date', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Firestoreからデータ取得する際のエラー
              if (snapshot.hasError || !snapshot.hasData) {
                return new Text('データを取得できませんでした');
              }

              switch (snapshot.connectionState) {
                // Firestoreに問い合わせ中の表示
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());

                default:
                  events = snapshot.data.docs;

                  // 表示すべきイベントがない場合
                  if (events.isEmpty) {
                    return Center(child: Text('イベントが見つかりませんでした'));
                  }

                  // 検索窓
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: SearchBar<DocumentSnapshot>(
                      onSearch: search,
                      suggestions: events,
                      searchBarStyle: SearchBarStyle(
                          backgroundColor: Colors.white,
/*                        padding: EdgeInsets.symmetric(
                          horizontal: 120.0
                        ),

 */
                          borderRadius: BorderRadius.circular(10)),
                      minimumChars: 1,
                      cancellationWidget: Icon(Icons.cancel_outlined),
//                      cancellationWidget: Text('キャンセル'),
                      emptyWidget: Center(child: Text('一致するイベントはありません')),
                      hintText: 'イベント名',
                      hintStyle: TextStyle(fontSize: 20),
                      onItemFound: (DocumentSnapshot event, int index) {
                        // 検索結果
                        Event event = new Event(
                            events[index].reference.id,
                            events[index].data()['event_title'],
                            events[index].data()['event_date'],
                            events[index].data()['event_details']);

                        return EventCard(event: event, displayAll: true);
/*
                        DateTime eventDate =
                            events[index]["event_date"].toDate();
                        final double numberSize = 20.0;
                        final double letterSize = 10.0;

                        // 1イベント分のCard
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // イベント名
                              Row(children: [
                                SpaceBox.width(30),
                                Expanded(
                                    child: ListTile(
                                        title: Text(
                                            events[index]["event_title"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Colors.grey[850])),

                                        // 共有ボタン
                                        trailing: IconButton(
                                            icon: Icon(Icons.share),
                                            onPressed: () {
                                              Share.share(
                                                  "Link to open this particular event in OnTime App");
                                            }))),
                              ]),

                              // 開催日時
                              Row(children: [
                                SpaceBox.width(50),
                                Text(
                                  eventDate.year.toString(),
                                  style: TextStyle(
                                      fontSize: numberSize,
                                      color: Colors.grey[800]),
                                ),
                                Text('年',
                                    style: TextStyle(
                                        fontSize: letterSize,
                                        color: Colors.grey[800]),

                                    // 異なる文字サイズを下揃えする
                                    strutStyle: StrutStyle(
                                      fontSize: numberSize,
                                    )),
                                Text(
                                  eventDate.month.toString(),
                                  style: TextStyle(
                                      fontSize: numberSize,
                                      color: Colors.grey[800]),
                                ),
                                Text('月',
                                    style: TextStyle(
                                        fontSize: letterSize,
                                        color: Colors.grey[800]),
                                    strutStyle: StrutStyle(
                                      fontSize: numberSize,
                                    )),
                                Text(
                                  eventDate.day.toString(),
                                  style: TextStyle(
                                      fontSize: numberSize,
                                      color: Colors.grey[800]),
                                ),
                                Text('日',
                                    style: TextStyle(
                                        fontSize: letterSize,
                                        color: Colors.grey[800]),
                                    strutStyle: StrutStyle(
                                      fontSize: numberSize,
                                    )),
                                SpaceBox.width(10),
                                Text(
                                  eventDate.hour.toString().padLeft(2, "0") +
                                      ':' +
                                      eventDate.minute
                                          .toString()
                                          .padLeft(2, "0"),
                                  style: TextStyle(
                                      fontSize: numberSize,
                                      color: Colors.grey[800]),
                                ),
                                Text('JST',
                                    style: TextStyle(
                                        fontSize: letterSize,
                                        color: Colors.grey[800]),
                                    strutStyle: StrutStyle(
                                      fontSize: numberSize,
                                    )),
                              ]),
                              SpaceBox.height(10),

                              // イベント画像
                              FutureBuilder(
                                  future: getURL(events[index].reference.id),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    // 画像URL取得中の表示
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return CircularProgressIndicator();
                                    }

                                    if (snapshot.hasData) {
                                      return ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxHeight: 150),
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
                                  child: Text(events[index]["event_details"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3, // 3行以上の説明文は省略表示
                                      style:
                                          TextStyle(color: Colors.grey[700])),
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
                                            borderRadius:
                                                BorderRadius.circular(3)),
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
                            ],
                          ),
                        );
 */
                      },
//                    itemCount: events.length + 1,
                    ),
                  );
              }
            },
          );
        }
        // Firebase初期化中の表示
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // 検索処理
  Future<List<DocumentSnapshot>> search(String search) async {
    return events
        .where((event) => event["event_title"].contains(search))
        .toList();
  }

  // Cloud Storage URL取得
  Future<String> getURL(String documentID) async {
    final String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('event_images/' + documentID + '.png')
        .getDownloadURL();
    return downloadURL;
  }
}

/*
// マージン記述簡略化用Widget
class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}

 */

/*
class SearchBarDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'OnTime',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new SearchBarDemoHome());
  }
}

class SearchBarDemoHome extends StatefulWidget {
  @override
  _SearchBarDemoHomeState createState() => new _SearchBarDemoHomeState();
}

class _SearchBarDemoHomeState extends State<SearchBarDemoHome> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('OnTime'),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  }

  _SearchBarDemoHomeState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: new Center(
          child: new Text("Don't look at me! Press the search button!")),
    );
  }
}

 */
