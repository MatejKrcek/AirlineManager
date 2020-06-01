import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

import './select_plane_screen.dart';
import '../models/user.dart';
import '../models/myFlights.dart';
import '../models/offer.dart';
import '../models/myAirplanes.dart';

class ClaimOfferScreen extends StatefulWidget {
  final bool isClaimed;
  final int index;

  ClaimOfferScreen(
    this.isClaimed,
    this.index,
  );

  @override
  _ClaimOfferScreenState createState() => _ClaimOfferScreenState();
}

class _ClaimOfferScreenState extends State<ClaimOfferScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<User> user = [];
  List<MyFlights> myFlights = [];
  List<MyAirplane> myPlanes = [];
  List<Offer> allFlights = [];
  bool isLoading = false;
  bool isLoadingOther = false;
  int position = 0;

  double progress = 0.2;
  String status = 'Departuring';
  Timer timer;

  Future getData() async {
    setState(() {
      isLoading = true;
      myFlights = [];
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
        myPlanes.sort((a, b) => a.name.compareTo(b.name));

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
              flightTime: flights[item]['flightTime'],
              arrivalTime: flights[item]['arrivalTime'],
              arrivalId: flights[item]['arrivalId'],
              departureId: flights[item]['departureId'],
              range: flights[item]['range'],
              minCapacity: flights[item]['minCapacity'],
            ),
          ];
          myFlights.add(prepsFlights[0]);
          if (DateTime.parse(myFlights[0].arrivalTime)
              .isAfter(DateTime.now())) {
            print('future');
            myFlights[0].onAir = true;
          } else {
            myFlights[0].onAir = false;
            // myActiveFlights.removeAt(0);
            print('done');
          }
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
        setState(() {
          isLoading = false;
        });
        setup();
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

  Future getFlights() async {
    setState(() {
      isLoadingOther = true;
      allFlights = [];
    });
    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=flights';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);

        if (map == null) {
          return;
        }
        for (var item in map.keys) {
          final List<Offer> flightList = [
            Offer(
              id: item,
              departureDes: map[item]['departureDes'],
              arrivalDes: map[item]['arrivalDes'],
              departureTime: map[item]['departureTime'],
              expiration: map[item]['expiration'],
              range: map[item]['range'],
              time: map[item]['flightTime'],
              price: map[item]['reward'],
              created: map[item]['created'],
              minCapacity: map[item]['minCapacity'],
            ),
          ];
          // print(flightList[0].departureDes);
          setState(() {
            allFlights.add(flightList[0]);
          });
        }
        print(allFlights.length);

        setState(() {
          isLoadingOther = false;
        });
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

  _navigate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ChooseAirplane(myPlanes, allFlights, widget.index)),
    );
    setState(() {
      position = result;
    });
  }

  void setup() {
    if (myFlights[widget.index].onAir) {
      DateTime arrival = DateTime.parse(myFlights[widget.index].arrivalTime);
      Duration difference = arrival.difference(DateTime.now());
      print(difference);

      setState(() {
        status = 'On Flight';
        progress = 1 /
            (double.parse(myFlights[widget.index].arrivalTime.toString()) * 60);
      });
      print(progress);
      //zavolat Timer
    }
    setState(() {
      progress = 1;
      status = 'Arrival';
    });
  }

  @override
  void dispose() {
    super.dispose();
    // timer?.cancel();
    // countdown.cancel();
  }

  @override
  void initState() {
    super.initState();
    getData();
    getFlights();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => update());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.isClaimed ? 'View Offer' : 'Claim Offer'),
      ),
      body: isLoading && isLoadingOther
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(!widget.isClaimed
                              ? '${allFlights[widget.index].departureDes} -> ${allFlights[widget.index].arrivalDes}'
                              : '${myFlights[widget.index].departureDes} -> ${myFlights[widget.index].arrivalDes}'),
                        ),
                        if (widget.isClaimed)
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  left: 15,
                                  bottom: 5,
                                ),
                                child: Text(
                                  'Flight ID: ${myFlights[widget.index].flightNumber}',
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
                                widget.isClaimed
                                    ? 'Flight Time: ${myFlights[widget.index].flightTime} minutes'
                                    : 'Flight Time: ${allFlights[widget.index].time} minutes',
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
                              child: RichText(
                                text: TextSpan(
                                  text: 'Capacity: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.isClaimed
                                          ? myFlights[widget.index]
                                              .minCapacity
                                              .toString()
                                          : allFlights[widget.index]
                                              .minCapacity
                                              .toString(),
                                      style: TextStyle(
                                          color:
                                              myFlights[position].minCapacity >=
                                                      allFlights[widget.index]
                                                          .minCapacity
                                                  ? Colors.black
                                                  : Colors.red,
                                          fontWeight:
                                              myFlights[position].minCapacity >=
                                                      allFlights[widget.index]
                                                          .minCapacity
                                                  ? FontWeight.normal
                                                  : FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: ' seats',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
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
                              child: RichText(
                                text: TextSpan(
                                  text: 'Range ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.isClaimed
                                          ? myFlights[widget.index]
                                              .range
                                              .toString()
                                          : allFlights[widget.index]
                                              .range
                                              .toString(),
                                      style: TextStyle(
                                          color: myFlights[position].range >=
                                                  allFlights[widget.index].range
                                              ? Colors.black
                                              : Colors.red,
                                          fontWeight: myFlights[position]
                                                      .range >=
                                                  allFlights[widget.index].range
                                              ? FontWeight.normal
                                              : FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: ' km',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
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
                                widget.isClaimed
                                    ? 'Reward: ${myFlights[widget.index].reward} coins'
                                    : 'Reward: ${allFlights[widget.index].price} coins',
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
                        if (!widget.isClaimed)
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  left: 15,
                                  bottom: 5,
                                ),
                                child: Text(
                                  isLoadingOther && isLoading
                                      ? 'Loading...'
                                      : 'Selected Airplane: ${myPlanes[position].name}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: FlatButton(
                                child: Text(
                                  'SELECT AIRPLANE',
                                  style: TextStyle(
                                      color: widget.isClaimed
                                          ? Colors.grey
                                          : Theme.of(context).primaryColor),
                                ),
                                onPressed: widget.isClaimed
                                    ? null
                                    : () {
                                        _navigate();
                                      },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: FlatButton(
                                child: Text(
                                  'CLAIM',
                                  style: TextStyle(
                                      color: widget.isClaimed
                                          ? Colors.grey
                                          : myPlanes[position].distance >=
                                                      allFlights[widget.index]
                                                          .range ||
                                                  myPlanes[position].seats >=
                                                      allFlights[widget.index]
                                                          .minCapacity
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey),
                                ),
                                onPressed: widget.isClaimed
                                    ? null
                                    : (myPlanes[position].distance >=
                                                allFlights[widget.index]
                                                    .range ||
                                            myPlanes[position].seats >=
                                                allFlights[widget.index]
                                                    .minCapacity)
                                        ? () {}
                                        : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: 30,
                          right: 10,
                          left: 10,
                        ),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          value: progress,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 2),
                            child: Text(myFlights[widget.index].departureId),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10, top: 2),
                            child: Text(myFlights[widget.index].arrivalId),
                          ),
                        ],
                      ),
                      if (progress == 1)
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('Status: $status'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
