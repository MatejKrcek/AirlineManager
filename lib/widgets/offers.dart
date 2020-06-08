import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/claim_offer_screen.dart';
import '../providers/offers_provider.dart';
import '../providers/user_provider.dart';

class Offers extends StatelessWidget {
  final bool onFlight;

  Offers(
    this.onFlight,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<OffersProvider>(context, listen: false).getFlights(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              child: const CircularProgressIndicator(),
            ),
          );
        } else {
          final data = Provider.of<UserProvider>(context, listen: false);
          final call = data.getFlights();
          final myRunningFlights = data.myActiveFlights;
          return Consumer<OffersProvider>(
            builder: (ctx, offers, _) =>
                onFlight && (offers.myRunningFlights.length == 0 || myRunningFlights.length == 0)
                    ? Center(
                        child: const Text(
                            'Quite empty, isn\'t it? Maybe check filters.'),
                      )
                    : ListView.builder(
                        itemCount: onFlight
                            ? offers.myRunningFlights.length
                            : offers.allFlights.length,
                        itemBuilder: (context, index) => Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(onFlight
                                    ? '${offers.myRunningFlights[index].departureDes} -> ${offers.myRunningFlights[index].arrivalDes}'
                                    : '${offers.allFlights[index].departureDes} -> ${offers.allFlights[index].arrivalDes}'),
                                subtitle: Text(onFlight
                                    ? 'Reward: ${offers.myRunningFlights[index].reward.toString()} coins'
                                    : 'Reward: ${offers.allFlights[index].price.toString()} coins'),
                                trailing: FlatButton(
                                  onPressed: () {
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          );
        }
      },
    );
  }
}
