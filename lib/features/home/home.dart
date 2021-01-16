import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import "../../entity/event.dart";
import "../../entity/query_parameter.dart";
import "../../common/app_bar.dart";
import "../../common/event_card.dart";
import "../../common/drawer.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loggedIn;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
//          setState(() {
      if (user == null) {
        print('yet');
        _loggedIn = false;
      } else {
        print('done');
        _loggedIn = true;
      }
//        });
    });
    print(_loggedIn);
    return new MyScaffold(login: _loggedIn);
  }

  /// Dynamic Link対応
  /// インストール済みの場合
/*
  @override
  void initState() {
    super.initState();
    _getLoggedIn();
    _initDynamicLinks(_loggedIn);
      print('in initState');
  }

  /// ログイン済みかどうか
  void _getLoggedIn() {
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
  if (user == null) {
    print('yet');
    _loggedIn = false;
  } else {
  print('done');
    _loggedIn = true;
  }
  });
//    return await FirebaseAuth.instance.onAuthStateChanged.hasData;
  }

  void _initDynamicLinks(bool loggedIn) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          Map<String, String> map = deepLink.queryParameters;
          if (deepLink != null) {
            String eventId = Map.from(map)['id'];
            String password = Map.from(map)['pass'];
            QueryParameter queryParameter =
            new QueryParameter(eventId: eventId, password: password);
            if (!loggedIn) {
              Navigator.pushNamed(context, '/auth', arguments: queryParameter);
            } else {
              Navigator.pushNamed(context, '/schedule', arguments: queryParameter);
            }
          }
        }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }
 */
}

class MyScaffold extends StatefulWidget {
  final login;
  MyScaffold({this.login});
  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  /// AppBarからDrawerを呼ぶためのキー
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return new Scaffold(
        appBar: MyAppBar(_key),
        body:

            /// AppBarを最前面にするために二重に
            Scaffold(
          body: SafeArea(
            child: EventCards(),
          ),
          floatingActionButton: widget.login
              ? Container(width: 0, height: 0)
/*
          /// チャットボタン表示
          FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                  child: new Icon(Icons.chat))
 */

              : Container(
                  width: 0.7 * screenWidth,
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.pushNamed(context, '/auth');
                      },
                      label: Text('ログイン'))),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          drawerEdgeDragWidth: 0,
          drawer: SizedBox(width: 0.8 * screenWidth, child: MyDrawer()),
          key: _key,
        ));
  }

}

/// 一イベント分の表示
class EventCards extends StatefulWidget {
  @override
  _EventCardsState createState() => _EventCardsState();
}

class _EventCardsState extends State<EventCards> {
  List<DocumentSnapshot> events;

  @override
  Widget build(BuildContext context) {
        /// Firestoreからイベントリストを取得
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')

          // 過去（1日以上前）のイベントは表示しない
          .where('event_date',
              isGreaterThan: DateTime.now().add(Duration(days: 1) * -1))
//                isGreaterThan: DateTime.now().add(Duration(days: 10)))
          .orderBy('event_date', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      id: events[index].reference.id,
                      eventTitle: events[index].data()['event_title'],
                      eventDate: events[index].data()['event_date'],
                      eventDetails: events[index].data()['event_details']);

                  return EventCard(event: event, displayAll: true);
                },
              ),
            );
        }
      },
    );
  }
  /*
        // Firebase初期化中の表示
        return Center(child: CircularProgressIndicator());
      },
    );
  }

         */

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

