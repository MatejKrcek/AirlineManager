import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math';
import 'dart:convert' as convert;

import '../widgets/auth_form.dart';
import '../models/user.dart';
import './main_overview_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;

  Future<void> _submitAuthForm(
    String username,
    String airlineName,
    BuildContext ctx,
  ) async {
    // print(username);
    // print(airlineName);

    // if (!prefs.containsKey('data')) {
    //   print('oops');
    //   return false;
    // }

    // final extractedUserData =
    //     convert.jsonDecode(prefs.getString('data')) as Map<String, Object>;
    // final id = extractedUserData['id'];

    try {
      setState(() {
        _isLoading = true;
      });
      var url =
          'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/personCreate?personName=$username';

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);

        String id = jsonResponse['personId'];
        print(id);

        setState(() {
          User.uid = id;
        });

        final prefs = await SharedPreferences.getInstance();
        final key = 'data';
        final userData = convert.jsonEncode({
          'username': username,
          'airlineName': airlineName,
          'id': id,
        });
        prefs.setString(key, userData);
        print('saved $userData');
      }

      print('done');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainOverviewScreen()),
      );
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
              AuthForm(_submitAuthForm, _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
