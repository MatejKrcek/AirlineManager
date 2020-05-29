import 'package:flutter/material.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../widgets/app_drawer.dart';
import '../models/user.dart';
import '../models/airplane.dart';
import '../models/offer.dart';
import '../models/myAirplanes.dart';
import '../models/myFlights.dart';

class MainOverviewScreen extends StatefulWidget {
  @override
  _MainOverviewScreenState createState() => _MainOverviewScreenState();
}

class _MainOverviewScreenState extends State<MainOverviewScreen> {
  bool isLoading = false;

  final List<User> user = [];
  List<MyFlights> myFlights = [];
  List<MyAirplane> myPlanes = [];
  int countPlanes = 0;
  int countFlights = 0;

  Future getData() async {
    setState(() {
      isLoading = true;
      countPlanes = 0;
      countFlights = 0;
      myFlights = [];
      myPlanes = [];
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

        var airplanes = map['aircrafts'];
        for (var item in airplanes.keys) {
          List<MyAirplane> preps = [
            MyAirplane(
              id: item,
              name: airplanes[item]['name'],
              imageUrl: airplanes[item]['imageUrl'],
              seats: airplanes[item]['capacity'],
              price: airplanes[item]['price'],
              onFlight: airplanes[item]['onFlight'],
              distance: airplanes[item]['range'],
              totalFlightDistance: airplanes[item]['totalDistance'],
              speed: airplanes[item]['speed'],
              totalFlightTime: airplanes[item]['totalFlightTime'],
              totalFlights: airplanes[item]['totalFlights'],
              aircraftIdentity: airplanes[item]['aircraftIdentity'],
            ),
          ];
          myPlanes.add(preps[0]);
        }
        countPlanes = myPlanes.length - 1;

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
            ),
          ];
          myFlights.add(prepsFlights[0]);
        }
        // print(myFlights[countFlights].departureDes);
        countFlights = myPlanes.length - 1;
        print(countFlights);
        print(myPlanes.length);
        // print(myFlights[countFlights].departureDes);

        final List<User> newUser = [
          User(
            id: "0d865038-de6d-4d50-9728-37a415ad8bdd",
            username: map['name'],
            airlineName: map['airlineName'],
            coins: map['coins'],
            gems: map['gems'],
            pilotRank: map['pilotRank'],
            gameLevel: map['gameLevel'],
            profilePictureUrl: map['profilePictureUrl'],
            totalFlightDistance: map['flightDistance'],
            totalFlightTime: map['flightTime'],
            // aircrafts: MyAirplane.add(),
            // flights: myFlights[0],
            created: map['dateCreation'],
            login: map['dateLogin'],
          ),
        ];
        user.add(newUser[0]);
        print(countPlanes);
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
    getData();
    // getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airline Overview'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => getData(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(isLoading
                          ? 'Loading...'
                          : 'User: ${user[0].username}'),
                      trailing: Text(isLoading
                          ? 'Loading...'
                          : 'Coins: ${user[0].coins.toString()}'),
                    ),
                    ListTile(
                      title: Text(isLoading
                          ? 'Loading...'
                          : 'Airline: ${user[0].airlineName}'),
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
                      title: Text('Featured offers'),
                      trailing: FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/offers-screen');
                        },
                        child: Text(
                          'View All',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 150,
                      child: !isLoading
                          ? ListView.builder(
                              itemCount: countFlights - 1,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(
                                  isLoading
                                      ? 'Loading...'
                                      : '${myFlights[index].departureDes} -> ${myFlights[index].arrivalDes}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                subtitle: Text(isLoading
                                    ? 'Loading...'
                                    : 'Claim ${myFlights[index].reward.toString()} coins now!'),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
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
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: countPlanes == 0 ? 100 : 235,
                      child: Container(
                        height: 230,
                        child: countPlanes == 0
                            ? Center(
                                child: Text(
                                    'Hey! You have no airplane! Visit shop!'))
                            : ListView.builder(
                                itemCount: countPlanes + 1,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 160,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: 160,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            myPlanes[index].imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        isLoading
                                            ? 'Loading...'
                                            : myPlanes[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              isLoading
                                                  ? 'Loading...'
                                                  : 'Range: ${myPlanes[index].distance.toString()} km',
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
                                              isLoading
                                                  ? 'Loading...'
                                                  : 'Seats: ${myPlanes[index].seats.toString()}',
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        myPlanes[index].onFlight == ""
                                            ? 'Available'
                                            : 'On Flight',
                                        style: TextStyle(
                                          color: myPlanes[index].onFlight == ""
                                              ? Colors.green
                                              : Colors.red,
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
      ),
    );
  }
}
