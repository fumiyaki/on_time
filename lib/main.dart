import 'dart:async';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'common/auth_model.dart';
import 'features/event_setup/widgets/event_setup.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'features/home/home.dart';
import 'features/detail/detail.dart';
import 'features/auth/auth.dart';
import 'features/login.dart';
import 'features/login_success.dart';
import 'features/chat/chat.dart';
import 'feature/edit/edit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  dynamicLinksHandlerNonInstall();
  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'onTime',
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/': (context) => Home(),
        '/auth': (context) => auth(),
        '/login': (context) => AuthScreen(),
        '/loggedIn': (context) => SomeScreen(),
        '/detail': (context) => detailPage(),
        '/setup': (context) => MyCustomForm(),
//        '/chat': (context) => MyHomePage(),
        '/chat': (context) => ChatScreen(),
        '/edit': (context) => EditPage()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false
    );
  }
}


/// Dynamic Link対応
/// 未インストールの場合
/// dynamicLinksHandlerNonInstall を main() 内で実行
void dynamicLinksHandlerNonInstall() async {
  final data = await FirebaseDynamicLinks.instance.getInitialLink();
  final Uri deepLink = data?.link;
  /// do something...
}
