import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:provider/provider.dart';

import './screens/offers_overview_screen.dart';
import './screens/main_overview_screen.dart';
import './screens/inventory_screen.dart';
import './screens/shop_screen.dart';
import './screens/stats_screen.dart';
import './screens/auth_screen.dart';
import './providers/user_provider.dart';

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
    return ChangeNotifierProvider(
      create: (ctx) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Airline Manager',
        theme: ThemeData(
          primaryColor: Color(0xFFFFC61F),
          accentColor: Color.fromRGBO(40, 51, 74, 1),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Color.fromRGBO(40, 51, 74, 0.9)),
            bodyText2: TextStyle(color: Color.fromRGBO(40, 51, 74, 0.9)),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: createAcc ? AuthScreen() : MainOverviewScreen(),
        routes: {
          OffersOverviewScreen.routeName: (ctx) => OffersOverviewScreen(),
          InventoryScreen.routeName: (ctx) => InventoryScreen(),
          ShopScreen.routeName: (ctx) => ShopScreen(),
          StatsScreen.routeName: (ctx) => StatsScreen(),
        },
      ),
    );
  }
}
