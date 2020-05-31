import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'dart:math';

import '../widgets/auth_form.dart';
import '../models/user.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  var _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    print('start');
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        String myId = authResult.user.uid;
        User.uid = myId;
        print(User.uid);

      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        var url =
            'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/personCreate?personId=${authResult.user.uid}&personName=$username';

        await http.get(url);

        String myId = authResult.user.uid;
        User.uid = myId;
        print(User.uid);

        print('done');
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser _user = authResult.user;

    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(_user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $_user';
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // RaisedButton(
              //   child: Text('Sign with Google'),
              //   onPressed: () {
              //     signInWithGoogle().whenComplete(() => print('done'));
              //   },
              // ),
              // RaisedButton(
              //   child: Text('Sign out'),
              //   onPressed: () {
              //     signOutGoogle();
              //   },
              // ),
              // SizedBox(
              //   height: 30,
              // ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 54.0),
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  // ..translate(-10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).accentColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    'Airline Manager',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 43,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              AuthForm(_submitAuthForm, _isLoading, signInWithGoogle),
            ],
          ),
        ),
      ),
    );
  }
}
