import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
import "../../common/auth_model.dart";

/// ホーム画面（イベント一覧）
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loggedIn = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  StreamController<bool> _controller = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
        appBar: MyAppBar(_key),
        body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {

            /// AppBarを最前面にするためにScaffoldを二重に
            return Scaffold(
          body:
          SafeArea(
            child: EventCards(),
          ),

          /// 未ログイン時のみログインボタン表示
          floatingActionButton: _loggedIn
              ? Container(width: 0, height: 0)
              : Container(
                  width: 0.7 * screenWidth,
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.pushNamed(context, '/auth').then((value) {
                          setState(() {
                            print('back');
                          });
                        });
                      },
                      label: Text('ログイン'))),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          /// ドロワー
          drawerEdgeDragWidth: 0,
          drawer: SizedBox(
              width: 0.8 * screenWidth, child: MyDrawer(login: _loggedIn)),
          key: _key,
        );}
            ));
  }


/// Dynamic Link対応
/// アプリインストール済みの場合の処理
///　ログイン状態をみた上で飛ばす先の画面をauthかdetailか判定したい
/// まだうまく行ってない
  @override
  void initState() {
    super.initState();

      FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        _loggedIn = false;
      } else {
        _loggedIn = true;
      }
    });
      _controller.add(_loggedIn);
//    _initDynamicLinks(_loggedIn);
  }
/*
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

/// イベント一覧の部分
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

  /// 検索処理
  Future<List<DocumentSnapshot>> search(String search) async {
    return events
        .where((event) => event["event_title"].contains(search))
        .toList();
  }

  /// Cloud Storage URL取得
  Future<String> getURL(String documentID) async {
    final String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('event_images/' + documentID + '.png')
        .getDownloadURL();
    return downloadURL;
  }
}
