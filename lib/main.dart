import 'package:flutter/material.dart';
import 'package:kiwi/screens/auth_screen.dart';
import 'package:provider/provider.dart';

import './screens/offers_overview_screen.dart';
import './screens/main_overview_screen.dart';
import './screens/inventory_screen.dart';
import './screens/shop_screen.dart';
import './screens/stats_screen.dart';
import './providers/user_provider.dart';
import './providers/auth_provider.dart';
import './providers/offers_provider.dart';
import './providers/kiwi_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          update: (ctx, auth, _) => UserProvider(auth.userId),
          create: (BuildContext context) {
            return;
          },
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => OffersProvider(),
        // ),
        ChangeNotifierProxyProvider<UserProvider, OffersProvider>(
          update: (ctx, user, _) =>
              OffersProvider(user.myActiveFlights, user.myPlanes, user.userId),
          create: (BuildContext context) {
            return;
          },
        ),
        ChangeNotifierProxyProvider<OffersProvider, KiwiProvider>(
          update: (ctx, offer, _) =>
              KiwiProvider(offer.myRunningFlights, offer.allFlights),
          create: (BuildContext context) {
            return;
          },
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
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
          home: auth.userId != null
              ? MainOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : AuthScreen(),
                ),
          routes: {
            OffersOverviewScreen.routeName: (ctx) => OffersOverviewScreen(),
            InventoryScreen.routeName: (ctx) => InventoryScreen(),
            ShopScreen.routeName: (ctx) => ShopScreen(),
            StatsScreen.routeName: (ctx) => StatsScreen(),
          },
        ),
      ),
    );
  }
}
