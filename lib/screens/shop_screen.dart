import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../widgets/app_drawer.dart';
import '../models/airplane.dart';
import '../models/user.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = '/shop-screen';

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;

  final List<User> user = [];
  final List<Airplane> listOfAirplanes = [];
  int countPlanes = 0;

  Future getData() async {
    setState(() {
      isLoading = true;
      countPlanes = 0;
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

  Future getAirlanes() async {
    setState(() {
      isLoading = true;
    });
    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=aircrafts';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);

        if (map == null) {
          return;
        }

        for (var item in map.keys) {
          final List<Airplane> airplaneListDb = [
            Airplane(
              id: item,
              name: map[item]['name'],
              speed: map[item]['speed'],
              price: map[item]['price'],
              seats: map[item]['capacity'],
              distance: map[item]['range'],
              imageUrl: map[item]['imageUrl'],
            ),
          ];
          // print(airplaneListDb[0]);
          setState(() {
            listOfAirplanes.add(airplaneListDb[0]);
          });
        }
        setState(() {
          isLoading = false;
        });

        listOfAirplanes.sort((a, b) => a.name.compareTo(b.name));
        print(listOfAirplanes[0].name);
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

  Future buyAirplane(int index) async {
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/buyAircraft?personId=${user[0].id}&aircraftIdentity=${listOfAirplanes[index].id}';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);

        if (map == null) {
          return;
        }

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
    getAirlanes();
  }

  void _buy(int index) async {
    if (user[0].coins >= listOfAirplanes[index].price) {
      user[0].coins = user[0].coins - listOfAirplanes[index].price;
      // removeCoins(listOfAirplanes[index].price);

      // myAirplanes.add(listOfAirplanes[index]);
      // print(myAirplanes.length);

      await buyAirplane(index);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Congrats! Check your inventory'),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } else {
      print('Not enought coins');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Not enought coins!'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
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
              text: 'Do you want to buy ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: listOfAirplanes[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' for ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: listOfAirplanes[index].price.toString(),
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
              child: Text("Buy now"),
              onPressed: () {
                _buy(index);
                Navigator.of(context).pop();
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
        title: Text('Shop'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => getData(),
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 5,
                child: ListTile(
                  title: Text(isLoading
                      ? 'Loading...'
                      : 'Coins: ${user[0].coins.toString()}'),
                ),
              ),
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Airplanes',
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      child: Container(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: listOfAirplanes.length,
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
                                            listOfAirplanes[index].imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        listOfAirplanes[index].name,
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
                                              'Range: ${listOfAirplanes[index].distance.toString()} km',
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
                                              'Seats: ${listOfAirplanes[index].seats.toString()}',
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
                                              'Speed: ${listOfAirplanes[index].speed.toString()}',
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${listOfAirplanes[index].price.toString()} coins',
                                      ),
                                      FlatButton(
                                        onPressed: user[0].coins <
                                                listOfAirplanes[index].price
                                            ? null
                                            : () {
                                                _showDialog(index);
                                              },
                                        child: Text(
                                          'Buy now',
                                          style: TextStyle(
                                            color: user[0].coins <
                                                    listOfAirplanes[index].price
                                                ? Colors.grey
                                                : Theme.of(context)
                                                    .primaryColor,
                                          ),
                                        ),
                                      )
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
