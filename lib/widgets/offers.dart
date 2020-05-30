import 'package:flutter/material.dart';
import 'package:kiwi/screens/flight_screen.dart';

import '../models/myFlights.dart';
import '../models/offer.dart';

class Offers extends StatelessWidget {
  final List<Offer> flights;
  final List<MyFlights> myActiveFlights;

  Offers(this.flights, this.myActiveFlights);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: flights.length,
      itemBuilder: (context, index) => Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(myActiveFlights.length - 1 >= index
                  ? '${myActiveFlights[index].departureDes} -> ${myActiveFlights[index].arrivalDes}'
                  : '${flights[index].departureDes} -> ${flights[index].arrivalDes}'),
              subtitle: Text(myActiveFlights.length - 1 >= index
                  ? 'Reward: ${myActiveFlights[index].reward.toString()} coins'
                  : 'Reward: ${flights[index].price.toString()} coins'),
              trailing: FlatButton(
                  onPressed: () {
                    if (myActiveFlights.length - 1 >= index) {
                      for (var i = 0; i <= index - i; i++) {
                        print('cau');
                        if (flights[i].departureDes ==
                                myActiveFlights[i].departureDes &&
                            flights[i].arrivalDes ==
                                myActiveFlights[i].arrivalDes &&
                            flights[i].price ==
                                myActiveFlights[i].reward) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FlightScreen(true, index)),
                          );
                        }
                      }
                    } else {
                      print('asss');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FlightScreen(false, index)),
                      );
                    }
                  },
                  child: Text(
                    myActiveFlights.length - 1 >= index ? 'VIEW' : 'CLAIN NOW',
                    style: TextStyle(
                        color: myActiveFlights.length - 1 >= index
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
