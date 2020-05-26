import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../widgets/app_drawer.dart';
import '../models/airplane.dart';
import '../models/user.dart';
import '../storage/data.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = '/shop-screen';

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final List<Airplane> listOfAirplanes = [
    Airplane(
      name: 'Airbus A330',
      price: 10300,
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

  List<Airplane> myAirplanes = [
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
      coins: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    getCoins();
  }

  Future getCoins() async {
    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/creditShow?userId=XYZ';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);

        setState(() {
          users[0].coins = jsonResponse['credit'];
        });
        print(jsonResponse['credit']);
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  Future removeCoins(int removeAmount) async {
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/creditRemove?userId=XYZ&creditAmount=$removeAmount';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse['credit']);
        getCoins();
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  void _buy(int index) {
    if (users[0].coins >= listOfAirplanes[index].price) {
      users[0].coins = users[0].coins - listOfAirplanes[index].price;
      removeCoins(listOfAirplanes[index].price);

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
                    height: 250,
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
