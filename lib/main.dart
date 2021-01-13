import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
//import 'feature/home/home.dart';
import 'common/drawer.dart';

import 'feature/chat/chat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}
//void main() => runApp(SearchBarDemoApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'OnTime';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: MyHomePage(),
//    home: SearchBarDemoHome(),
        routes: <String, WidgetBuilder> {
/*
        AuthPage.routeName: (context) => AuthPage(),
        SchedulePage.routeName: (context) => SchedulePage(),
        ChatPage.routeName: (context) => MyHomePage()
*/
        }
    );
  }
}
