import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "Airline ",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: "Manager",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart),
              title: const Text('Overview'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.local_offer),
              title: const Text('Flight Offers'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/offers-screen');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.airplanemode_active),
              title: const Text('Inventory'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/inventory-screen');
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/shop-screen');
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/stats-screen');
              },
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    left: 5,
                  ),
                  child: const Text(
                    '0.9.4+1 Alfa',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
