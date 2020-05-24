import 'package:flutter/material.dart';
import 'package:kiwi/widgets/app_drawer.dart';

import '../models/offer.dart';
import '../widgets/offers.dart';

class OffersOverviewScreen extends StatefulWidget {
  static const routeName = '/offers-screen';

  @override
  _OffersOverviewScreenState createState() => _OffersOverviewScreenState();
}

class _OffersOverviewScreenState extends State<OffersOverviewScreen> {
  final List<Offer> offerList = [
    Offer(
      id: 'p1',
      departureDes: 'Prague',
      arrivalDes: 'Kosice',
      price: 300,
      time: 10,
    ),
    Offer(
      id: 'p2',
      departureDes: 'Prague',
      arrivalDes: 'Brno',
      price: 50,
      time: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airline offers'),
      ),
      drawer: AppDrawer(),
      body: Offers(offerList),
    );
  }
}
