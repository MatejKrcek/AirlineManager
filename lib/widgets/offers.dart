import 'package:flutter/material.dart';

import '../screens/claim_offer_screen.dart';

import '../models/myFlights.dart';
import '../models/offer.dart';

class Offers extends StatelessWidget {
  final List<Offer> flights;
  final List<MyFlights> myActiveFlights;
  final bool onFlight;
  final List<MyFlights> myRunningFlights;

  Offers(
    this.flights,
    this.myActiveFlights,
    this.onFlight,
    this.myRunningFlights,
  );

  @override
  Widget build(BuildContext context) {
    return myRunningFlights.length == 0 && onFlight
        ? Center(child: Text('Quite empty, isn\'t it? Maybe check filters.'))
        : ListView.builder(
            itemCount: onFlight ? myRunningFlights.length : flights.length,
            itemBuilder: (context, index) => Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(onFlight
                        ? '${myRunningFlights[index].departureDes} -> ${myRunningFlights[index].arrivalDes}'
                        : '${flights[index].departureDes} -> ${flights[index].arrivalDes}'),
                    subtitle: Text(onFlight
                        ? 'Reward: ${myRunningFlights[index].reward.toString()} coins'
                        : 'Reward: ${flights[index].price.toString()} coins'),
                    trailing: FlatButton(
                        onPressed: () {
                          // if (myActiveFlights.length - 1 >= index) {
                          // for (var i = 0; i <= index - i; i++) {
                          //   if (flights[i].departureDes ==
                          //           myActiveFlights[i].departureDes &&
                          //       flights[i].arrivalDes ==
                          //           myActiveFlights[i].arrivalDes &&
                          //       flights[i].price ==
                          //           myActiveFlights[i].reward) {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               ClaimOfferScreen(true, index)),
                          //     );
                          //   }
                          // }

                          // }
                          if (onFlight) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClaimOfferScreen(true, index)),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClaimOfferScreen(false, index)),
                            );
                          }
                        },
                        child: Text(
                          onFlight ? 'VIEW' : 'CLAIM NOW',
                          style: TextStyle(
                              color: onFlight
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).primaryColor),
                        )),
                  ),
                ],
              ),
            ),
          );
  }
}
