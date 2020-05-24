import 'package:flutter/material.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../widgets/app_drawer.dart';
import '../models/user.dart';
import '../models/airplane.dart';
import '../models/offer.dart';

class MainOverviewScreen extends StatefulWidget {
  @override
  _MainOverviewScreenState createState() => _MainOverviewScreenState();
}

class _MainOverviewScreenState extends State<MainOverviewScreen> {
  List myActiveOffers = [1, 2, 3, 4, 5];

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

  final List<Airplane> myAirplanes = [
    Airplane(
      name: 'Airbus A330',
      price: 1030,
      distance: 1000,
      seats: 330,
      imageUrl:
          'https://airbus-h.assetsadobe2.com/is/image/content/dam/channel-specific/website-/products-and-services/aircraft/header/aircraft-families/A330-family-stage.jpg?wid=1920&fit=fit,1&qlt=85,0',
      onFlight: false,
    ),
    Airplane(
      name: 'Airbus A320',
      price: 800,
      distance: 900,
      seats: 200,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/d/d6/Airbus_A320-214%2C_CSA_-_Czech_Airlines_AN1841815.jpg',
      onFlight: false,
    ),
  ];

  final List<User> users = [
    User(
      username: 'Matej',
      airlineName: 'Kiwi Airlines',
      coins: 5000,
    ),
  ];

  data() async {
    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/creditShow?userId=XYZ';

    var response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse['credit']);

        setState(() {
          users[0].coins = jsonResponse['credit'];
        });
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  loadOffer() async {
    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/showOffers?userId=XYZ';

    var response = await http.get(url);

    try {
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
    loadOffer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airline Overview'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('User: ${users[0].username}'),
                    trailing: Text('Coins: ${users[0].coins}'),
                  ),
                  ListTile(
                    title: Text('Airline: ${users[0].airlineName}'),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Current offers'),
                    trailing: FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/offers-screen');
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: (offerList.length >=
                              2) //offers z database, vsechny, kde offers[index].isRunning = true;
                          ? 2
                          : offerList.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          '${offerList[index].departureDes} -> ${offerList[index].arrivalDes}',
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Text('Remaining: 3 mins'),
                        trailing: FlatButton(
                          onPressed: () {
                            data();
                          },
                          child: Text(
                            'Details',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'My Aircrafts',
                    ),
                    trailing: FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/inventory-screen');
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 235,
                    child: Container(
                      height: 230,
                      child: ListView.builder(
                        itemCount:
                            (myAirplanes.length >= 3) ? 4 : myAirplanes.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 160,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 160,
                                height: 100,
                                color: Colors.grey,
                                child: Image.network(
                                  myAirplanes[index].imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                myAirplanes[index].name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Range: ${myAirplanes[index].distance} km',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Seats: ${myAirplanes[index].seats}',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                myAirplanes[index].onFlight
                                    ? 'On Flight'
                                    : 'Available',
                                style: TextStyle(
                                  color: myAirplanes[index].onFlight
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
