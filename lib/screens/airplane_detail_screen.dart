import 'package:flutter/material.dart';

import '../models/airplane.dart';

class AirplaneDetailScreen extends StatefulWidget {
  final int index;

  AirplaneDetailScreen(
    this.index,
  );

  @override
  _AirplaneDetailScreenState createState() => _AirplaneDetailScreenState();
}

class _AirplaneDetailScreenState extends State<AirplaneDetailScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory - ${myAirplanes[widget.index].name}'),
      ),
      body: Container(
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
                  myAirplanes[widget.index].imageUrl,
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
                    title: Text('Name: ${myAirplanes[widget.index].name}'),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          bottom: 5,
                        ),
                        child: Text(
                          'Seats: ${myAirplanes[widget.index].seats}',
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
                          'Flight distance: ${myAirplanes[widget.index].distance}',
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
                          'Price: ${myAirplanes[widget.index].price}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
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
                          onPressed: () {},
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
