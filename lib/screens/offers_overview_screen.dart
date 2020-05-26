import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../widgets/app_drawer.dart';
import '../models/offer.dart';
import '../widgets/offers.dart';

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
  final List<Offer> offerList = [
    // Offer(
    //   id: 'p1',
    //   departureDes: 'Prague',
    //   arrivalDes: 'Kosice',
    //   price: 300,
    //   time: 10,
    //   isRunning: false,
    // ),
    // Offer(
    //   id: 'p2',
    //   departureDes: 'Prague',
    //   arrivalDes: 'Brno',
    //   price: 50,
    //   time: 5,
    //   isRunning: false,
    // ),
  ];

  Future data() async {
    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/showOffers?userId=XYZ';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);
        // print(map);
        var myOffers = map['myOffers'];

        for (var item in myOffers.keys) {
          // print(item['price']);
          // print(myOffers[item]['price']);
          final List<Offer> testofferList = [
            Offer(
              id: item,
              departureDes: myOffers[item]['departureDes'],
              arrivalDes: myOffers[item]['arrivalDes'],
              price: myOffers[item]['price'],
              time: myOffers[item]['flightTime'],
              isRunning: myOffers[item]['isRunning'],
            ),
          ];

          // print(testofferList[0].arrivalDes);
          setState(() {
            offerList.add(testofferList[0]);
          });

          // print('id: ${offerList[2].isRunning}');
        }
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airline offers'),
      ),
      drawer: AppDrawer(),
      body: offerList.isNotEmpty
          ? Offers(offerList)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
