import 'dart:async';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'features/home/home.dart';
import 'features/auth/auth.dart';
import 'features/schedule/schedule.dart';
import 'features/chat/chat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'OnTime';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/': (context) => Home(),
/*
        '/auth': (context) => AuthPage(),
        '/schedule': (context) => SchedulePage(),
*/
        'chat': (context) => MyHomePage()
      }
    );
  }
}
