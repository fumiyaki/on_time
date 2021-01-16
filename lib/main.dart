import 'dart:async';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'features/event_setup/widgets/event_setup.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'features/home/home.dart';
import 'features/schedule/schedule.dart';
import 'features/auth/auth.dart';
import 'features/event_setup/widgets/event_setup.dart';
import 'features/chat/chat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  dynamicLinksHandlerNonInstall();
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
//        '/setup': (context) => EventSetup(),
        '/setup': (context) => MyCustomForm(),
        '/chat': (context) => MyHomePage()
      }
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


/*

      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return SomeScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}


class AuthScreen extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  void logIn() async {
    GoogleSignInAccount signinAccount = await googleLogin.signInSilently();
    if (signinAccount == null) signinAccount = await googleLogin.signIn();
    if (signinAccount == null) return;

    GoogleSignInAuthentication auth = await signinAccount.authentication;
    final credential = GoogleAuthProvider.getCredential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
    FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: logIn,
          child: Text('login'),
        ),
      ),
    );
  }
}


class SomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticated'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Congrats!!'),
            SizedBox(height: 20),
            FlatButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app),
              label: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
*/
