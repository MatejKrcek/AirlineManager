import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class MainOverviewScreen extends StatefulWidget {
  @override
  _MainOverviewScreenState createState() => _MainOverviewScreenState();
}

class _MainOverviewScreenState extends State<MainOverviewScreen> {
  List myAircrafts = [1, 2, 3, 4];
  List myActiveOffers = [1, 2, 3, 4, 5];

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
                    title: Text('User: Mathej'),
                    trailing: Text('Coins: 3304'),
                  ),
                  ListTile(
                    title: Text('Airline: FlyEmirates'),
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
                      onPressed: () {},
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
                    height: 120,
                    child: ListView.builder(
                      itemCount: (myActiveOffers.length >= 2)
                          ? 2
                          : myActiveOffers.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          'Prague -> Kosice',
                          style: TextStyle(fontSize: 15),
                        ),
                        trailing: FlatButton(
                          onPressed: () {},
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
                      onPressed: () {},
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
                            (myAircrafts.length >= 3) ? 4 : myAircrafts.length,
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
                                child: Image.asset('assets/a330.jpg', fit: BoxFit.cover,),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Boing A300',
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
                                      'Range: 1000 km',
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
                                      'Seats: 300',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('On Flight'),
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
