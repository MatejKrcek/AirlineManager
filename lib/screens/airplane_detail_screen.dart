import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:kiwi/screens/inventory_screen.dart';
import 'dart:convert' as convert;

import '../models/user.dart';
import '../models/myAirplanes.dart';

class AirplaneDetailScreen extends StatefulWidget {
  final int index;

  AirplaneDetailScreen(
    this.index,
  );

  @override
  _AirplaneDetailScreenState createState() => _AirplaneDetailScreenState();
}

class _AirplaneDetailScreenState extends State<AirplaneDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  final List<User> user = [];
  List<MyAirplane> myPlanes = [];
  int countPlanes = 0;

  Future getData() async {
    setState(() {
      isLoading = true;
      countPlanes = 0;
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
        print(myPlanes.length);

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

  Future sell() async {
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/sellAircraft?personId=0d865038-de6d-4d50-9728-37a415ad8bdd&aircraftIdentity=${myPlanes[widget.index].id}';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        print('done');
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
    getData();
  }

  void _showDialog(int index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text("Are you sure?"),
          content: RichText(
            text: TextSpan(
              text: 'Do you want to sell ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myPlanes[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' for ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: myPlanes[index].price.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' coins?',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Sell now"),
              onPressed: () async {
                await sell();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            isLoading ? 'Detail' : 'Detail - ${myPlanes[widget.index].name}'),
      ),
      body: isLoading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        myPlanes[widget.index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text('Name: ${myPlanes[widget.index].name}'),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                left: 15,
                                bottom: 5,
                              ),
                              child: Text(
                                'Seats: ${myPlanes[widget.index].seats}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                left: 15,
                                bottom: 5,
                              ),
                              child: Text(
                                'Flight distance: ${myPlanes[widget.index].distance}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     Container(
                        //       margin: EdgeInsets.only(
                        //         left: 15,
                        //         bottom: 5,
                        //       ),
                        //       child: Text(
                        //         myAirplanes[widget.index].onFlight
                        //             ? 'Status: On Flight'
                        //             : 'Status: In Hangar',
                        //         textAlign: TextAlign.left,
                        //         style: TextStyle(
                        //           fontSize: 15,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                left: 15,
                                bottom: 5,
                              ),
                              child: Text(
                                'Price: ${myPlanes[widget.index].price}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: FlatButton(
                                child: Text(
                                  'SELL NOW',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                onPressed: () {
                                  _showDialog(widget.index);
                                },
                              ),
                            ),
                          ],
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
