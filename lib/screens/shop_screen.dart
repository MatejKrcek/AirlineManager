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

  final List<Airplane> listOfAirplanes = [];

  final List<Airplane> myAirplanes = [
    Airplane(
      name: 'Airbus A330',
      price: 1030,
      id: 'FSFA',
      distance: 1000,
      seats: 330,
      speed: 240,
      imageUrl:
          'https://airbus-h.assetsadobe2.com/is/image/content/dam/channel-specific/website-/products-and-services/aircraft/header/aircraft-families/A330-family-stage.jpg?wid=1920&fit=fit,1&qlt=85,0',
    ),
    Airplane(
      name: 'Airbus A320',
      price: 800,
      distance: 900,
      seats: 200,
      speed: 220,
      id: '8FSFA',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/d/d6/Airbus_A320-214%2C_CSA_-_Czech_Airlines_AN1841815.jpg',
    ),
  ];

  final List<User> users = [
    User(
      username: 'Matej',
      airlineName: 'Kiwi Airlines',
      coins: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    getAirlanes();
  }

  Future getAirlanes() async {
    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=aircrafts';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);
        // print(map);

        if (map == null) {
          return;
        }

        // var airplanes = map['airplanes'];
        // print(airplanes);
        // print(map);

        for (var item in map.keys) {
          // print(item['price']);
          // print(myOffers[item]['price']);
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
          print(airplaneListDb);
          // print(testofferList[0].arrivalDes);
          setState(() {
            listOfAirplanes.add(airplaneListDb[0]);
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }

  void _buy(int index) {
    if (users[0].coins >= listOfAirplanes[index].price) {
      users[0].coins = users[0].coins - listOfAirplanes[index].price;
      // removeCoins(listOfAirplanes[index].price);

      myAirplanes.add(listOfAirplanes[index]);
      print(myAirplanes.length);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Congrats!'),
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
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5,
              child: ListTile(
                title: Text('My coins: ${users[0].coins}'),
              ),
            ),
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Airbuses',
                    ),
                  ),
                  SizedBox(
                    height: 280,
                    child: Container(
                      child: ListView.builder(
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
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
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
                                onPressed: users[0].coins <
                                        listOfAirplanes[index].price
                                    ? null
                                    : () {
                                        _showDialog(index);
                                      },
                                child: Text(
                                  'Buy now',
                                  style: TextStyle(
                                    color: users[0].coins <
                                            listOfAirplanes[index].price
                                        ? Colors.grey
                                        : Theme.of(context).primaryColor,
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
    );
  }
}
