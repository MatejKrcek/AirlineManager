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
              leading: Icon(Icons.insert_chart),
              title: Text('Overview'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text('Flight Offers'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/offers-screen');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.airplanemode_active),
              title: Text('Inventory'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/inventory-screen');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/shop-screen');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.show_chart),
              title: Text('Statistics'),
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
                  child: Text(
                    '0.9.2 Beta',
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
