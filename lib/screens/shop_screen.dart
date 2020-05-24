import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = '/shop-screen';

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {},
              child: Text('Buy 300'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Get 300'),
            ),
            Text('Coins: '),
          ],
        ),
      ),
    );
  }
}
