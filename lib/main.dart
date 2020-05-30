import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import './screens/offers_overview_screen.dart';
import './screens/main_overview_screen.dart';
import './screens/inventory_screen.dart';
import './screens/shop_screen.dart';
import './screens/stats_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return AuthScreen();
            }
            if (userSnapshot.hasData) {
              return MainOverviewScreen();
            }

            return AuthScreen();
          }),
      routes: {
        OffersOverviewScreen.routeName: (ctx) => OffersOverviewScreen(),
        InventoryScreen.routeName: (ctx) => InventoryScreen(),
        ShopScreen.routeName: (ctx) => ShopScreen(),
        StatsScreen.routeName: (ctx) => StatsScreen(),
        //FlightScreen.routeName: (ctx) => FlightScreen(false, 0),
      },
    );
  }
}
