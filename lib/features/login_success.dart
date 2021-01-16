import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../common/app_bar.dart';

class SomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(_key),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Congrats!!'),
            SizedBox(height: 20),
            FlatButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
//                Navigator.pushNamed(context, '/auth');
                Navigator.popUntil(context, ModalRoute.withName('/'));
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