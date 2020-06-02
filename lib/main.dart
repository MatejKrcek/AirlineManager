import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/offers_overview_screen.dart';
import './screens/main_overview_screen.dart';
import './screens/inventory_screen.dart';
import './screens/shop_screen.dart';
import './screens/stats_screen.dart';
import './screens/auth_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool createAcc = true;

  void getData() async {
    final prefs = await SharedPreferences.getInstance();

    final extractedUserData =
        convert.jsonDecode(prefs.getString('data')) as Map<String, Object>;
    final id = extractedUserData['id'];
    print(id);
    if (!prefs.containsKey('data') || extractedUserData == null || id == null) {
      print('oops');
      setState(() {
        createAcc = true;
      });
    } else {
      setState(() {
        createAcc = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Airline Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: createAcc
          ? AuthScreen()
          : MainOverviewScreen(),
      routes: {
        OffersOverviewScreen.routeName: (ctx) => OffersOverviewScreen(),
        InventoryScreen.routeName: (ctx) => InventoryScreen(),
        ShopScreen.routeName: (ctx) => ShopScreen(),
        StatsScreen.routeName: (ctx) => StatsScreen(),
      },
    );
  }
}
