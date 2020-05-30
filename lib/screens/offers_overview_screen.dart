import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../widgets/app_drawer.dart';
import '../models/offer.dart';
import '../widgets/offers.dart';
import '../models/myFlights.dart';

class OffersOverviewScreen extends StatefulWidget {
  static const routeName = '/offers-screen';

  // final String id;
  // final bool isRunning;
  // final DateTime arrivalTime;

  // OffersOverviewScreen(this.id, this.isRunning, this.arrivalTime);

  @override
  _OffersOverviewScreenState createState() => _OffersOverviewScreenState();
}

class _OffersOverviewScreenState extends State<OffersOverviewScreen> {
  List<Offer> myFlights = [];
  List<MyFlights> myActiveFlights = [];
  bool isLoading = false;
  bool isLoadingOther = false;

  Future getFlights() async {
    setState(() {
      isLoadingOther = true;
      myFlights = [];
    });
    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=flights';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);

        if (map == null) {
          return;
        }
        for (var item in map.keys) {
          final List<Offer> flightList = [
            Offer(
              id: item,
              departureDes: map[item]['departureDes'],
              arrivalDes: map[item]['arrivalDes'],
              departureTime: map[item]['departureTime'],
              expiration: map[item]['expiration'],
              range: map[item]['range'],
              time: map[item]['flightTime'],
              price: map[item]['reward'],
              created: map[item]['created'],
              minCapacity: map[item]['minCapacity'],
            ),
          ];
          // print(flightList[0].departureDes);
          setState(() {
            myFlights.add(flightList[0]);
          });
        }
        print(myFlights.length);

        setState(() {
          isLoadingOther = false;
        });
      } else {
        print('error');
        setState(() {
          isLoadingOther = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future getMyFlights() async {
    setState(() {
      isLoading = true;
      myActiveFlights = [];
    });

    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=persons&personId=0d865038-de6d-4d50-9728-37a415ad8bdd';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);
        if (map == null) {
          return;
        }

        var flights = map['flights'];
        for (var item in flights.keys) {
          List<MyFlights> prepsFlights = [
            MyFlights(
              id: item,
              arrivalDes: flights[item]['arrivalDes'],
              departureDes: flights[item]['departureDes'],
              aircraft: flights[item]['aircraft'],
              departureTime: flights[item]['departureTime'],
              reward: flights[item]['reward'],
              onAir: flights[item]['onAir'],
              flightNumber: flights[item]['flightNo'],
              flightTime: flights[item]['flightTime'],
            ),
          ];
          myActiveFlights.add(prepsFlights[0]);
        }
        // print(myFlights[countFlights].departureDes);
        print(myActiveFlights.length);

        setState(() {
          isLoading = false;
        });
      } else {
        print('error');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getFlights();
    getMyFlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Offers'),
      ),
      drawer: AppDrawer(),
      body: !isLoading && !isLoadingOther
          ? Offers(myFlights, myActiveFlights)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
