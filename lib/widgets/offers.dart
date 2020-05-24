import 'package:flutter/material.dart';
import 'package:kiwi/screens/flight_screen.dart';

import '../models/offer.dart';

class Offers extends StatelessWidget {
  final List<Offer> offers;

  Offers(this.offers);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (context, index) => Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                  '${offers[index].departureDes} -> ${offers[index].arrivalDes}'),
              subtitle: Text(
                  '${offers[index].time} minutes, ${offers[index].price} USD'),
              trailing: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FlightScreen(
                              offers[index].id,
                              offers[index].arrivalDes,
                              offers[index].departureDes,
                              offers[index].price,
                              offers[index].time)),
                    );
                  },
                  child: Text(
                    'CLAIM NOW',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
