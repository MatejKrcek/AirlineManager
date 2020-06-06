import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


class AuthProvider with ChangeNotifier {
  String _userId;

  String get userId {
    return _userId;
  }

  Future<void> creataAcc(String username, String airlineName) async {
    print('create');
    try {
      var url =
          'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/personCreate?personName=$username';

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);

        _userId = jsonResponse['personId'];
        print(_userId);

        final prefs = await SharedPreferences.getInstance();
        final key = 'data';
        final userData = convert.jsonEncode({
          'username': username,
          'airlineName': airlineName,
          'id': _userId,
        });
        prefs.setString(key, userData);
        print('saved $userData');
      }
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('data')) {
      return;
    }

    final extractedUserData =
        convert.jsonDecode(prefs.getString('data')) as Map<String, Object>;
    _userId = extractedUserData['id'];
    notifyListeners();
  }
}
