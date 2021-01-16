import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  /*
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
   */
  void logIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Authentication'),
        ),
        body: Center(
            child: Column(children: [
              FlatButton(
                onPressed: () {logIn();
                Navigator.pushNamed(context, '/loggedIn');
            },
            child: Text('login'),
          ),
          FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loggedIn');
              },
              child: Text('force'))
        ])));
  }
}
