import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/src/services/message_codecs.dart';

class auth extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<UserCredential> signInWithGoogle() async {
// Trigger the authentication flow
    GoogleSignInAccount googleUser = _googleSignIn.currentUser;
    if (googleUser == null) googleUser = await _googleSignIn.signInSilently();
    if (googleUser == null) googleUser = await _googleSignIn.signIn();
    if (googleUser == null) print('Error while signing in');

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
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1],
            colors: [
              Color.fromRGBO(109, 113, 249, 1),
              Color.fromRGBO(91, 190, 253, 1),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('images/LogoAppBar.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Event Schedule Sharing App',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(56, 80, 56, 0),
                    child: OutlinedButton(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('images/google.png', width: 24),
                              Text('Google',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //]  fontWeight: FontWeight.bold,
                                  )),
                              Text('')
                            ],
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          primary: Colors.black,
                          shape: const StadiumBorder(),
                          side: const BorderSide(color: Colors.green),
                        ),
                        onPressed: () {
                          try {
                            final userCredential = signInWithGoogle();
                            Navigator.pushNamed(context, '/detail');
                          } on FirebaseAuthException catch (e) {
                            print('FirebaseAuthException');
                            print('${e.code}');
//                            Navigator.pushNamed(context, '/loggedIn');
                          } on Exception catch (e) {
                            print('Other Exception');
                            print('${e.toString()}');
//                            Navigator.pushNamed(context, '/loggedIn');
                          }
                        }),
                  ),
                ]),
          ),
        ));
  }
}

  /*
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
*/
