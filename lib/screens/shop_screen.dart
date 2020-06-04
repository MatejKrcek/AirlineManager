import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isLoadingOther = false;

  final List<User> user = [];
  final List<Airplane> listOfAirplanes = [];
  int countPlanes = 0;

  Future getData() async {
    setState(() {
      isLoading = true;
      countPlanes = 0;
    });

    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=persons&personId=${User.uid}';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);

        if (map == null) {
          return;
        }

        final List<User> newUser = [
          User(
            id: User.uid,
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
      isLoadingOther = true;
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
          isLoadingOther = false;
        });

        listOfAirplanes.sort((a, b) => a.name.compareTo(b.name));
        print(listOfAirplanes[0].name);
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
            id: User.uid,
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
      getData();
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
              child: Text(
                "Close",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Buy now",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            icon: SvgPicture.asset(
              "assets/svg/menu.svg",
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
        title: RichText(
          text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Airplane ",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              TextSpan(
                text: "Shop",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: !isLoading && !isLoadingOther
          ? RefreshIndicator(
              onRefresh: () => getData(),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(isLoading
                            ? 'Loading...'
                            : 'Coins: ${user[0].coins.toString()}'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Airplanes ",
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 0,
                            ),
                            width: double.infinity,
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listOfAirplanes.length,
                              itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: 170,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            listOfAirplanes[index].imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        isLoading
                                            ? 'Loading...'
                                            : listOfAirplanes[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              isLoading
                                                  ? 'Loading...'
                                                  : 'Range: ${listOfAirplanes[index].distance.toString()} km',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              isLoading
                                                  ? 'Loading...'
                                                  : 'Seats: ${listOfAirplanes[index].seats.toString()}',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              isLoading
                                                  ? 'Loading...'
                                                  : 'Speed: ${listOfAirplanes[index].speed.toString()}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 15,
                                              bottom: 5,
                                            ),
                                            child: Text(
                                              '${listOfAirplanes[index].price.toString()} coins',
                                              textAlign: TextAlign.center,
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
                                            child: FlatButton(
                                              onPressed: user[0].coins <
                                                      listOfAirplanes[index]
                                                          .price
                                                  ? null
                                                  : () {
                                                      _showDialog(index);
                                                    },
                                              child: Text(
                                                'BUY NOW',
                                                style: TextStyle(
                                                  color: user[0].coins <
                                                          listOfAirplanes[index]
                                                              .price
                                                      ? Colors.grey
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
