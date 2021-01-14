import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class auth extends StatelessWidget {
  Future<UserCredential> signInWithGoogle() async {
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
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Sign in Google'),
                onPressed: () {
        try {
          final userCredential = await signInWithGoogle();
        } on FirebaseAuthException catch (e) {
          print('FirebaseAuthException');
          print('${e.code}');
          Navigator.pushNamed(context, '/chat'))
        } on Exception catch (e) {
          print('Other Exception');
          print('${e.toString()}');
        }
}
                      
                },
              ),
            ]),
      ),
    );
  }
}
