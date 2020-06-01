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
  bool isClaimed;
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
  List<MyFlights> myRunningFlights = [];
  bool isLoading = false;
  bool isLoadingOther = false;
  bool claiming = false;
  int position;

  double progToAd = 0;
  double progress = 0;
  String status = 'Departuring';
  Timer timer;
  Timer countdown;
  final oneSec = const Duration(seconds: 1);

  Future getData() async {
    setState(() {
      isLoading = true;
      myFlights = [];
      myRunningFlights = [];
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
            myRunningFlights.add(myFlights[0]);
          } else {
            myFlights[0].onAir = false;
            // myFlights.removeAt(0);
            print('done');
          }
        }
        setState(() {
          isLoading = false;
        });
        print('LOADED');
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

        setState(() {
          isLoadingOther = false;
          // widget.isClaimed = true;
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

  Future claimOffer() async {
    if (position == null) {
      return;
    }
    setState(() {
      claiming = true;
    });
    print('TADY');
    print(allFlights[widget.index].id);
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/claimFlight?personId=${User.uid}&flightIdentity=${allFlights[widget.index].id}&myAircraftsId=${myPlanes[position].id}';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        print('claimed');

        setState(() {
          claiming = false;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Claimed!'),
          backgroundColor: Theme.of(context).errorColor,
        ));
      } else {
        print('error');
        setState(() {
          claiming = false;
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
    initState();
  }

  void update() {
    setState(() {
      progress = progress + progToAd;
    });
    if (progress > 1) {
      setState(() {
        status = 'Arrived';
      });
      timer.cancel();
    }
    if (progress > 0.1) {
      setState(() {
        status = 'On Air';
      });
    }
    if (progress > 0.9 && progress < 0.99) {
      setState(() {
        status = 'Arriving';
      });
    }
  }

  void setup() {
    if (myRunningFlights[widget.index].onAir) {
      print('onair');
      DateTime arrival =
          DateTime.parse(myRunningFlights[widget.index].arrivalTime);

      Duration difference = arrival.difference(DateTime.now());
      double currentDifference = difference.inSeconds.toDouble();
      double totalDifference =
          myRunningFlights[widget.index].flightTime.toDouble() * 60;
      setState(() {
        progToAd = 1 / totalDifference;
        progress = progToAd * (totalDifference - currentDifference);
      });
      // print('prog:');
      print(progToAd);
      print(progress);

      double timeLeft = myRunningFlights[widget.index].flightTime.toDouble();
      countdown = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (timeLeft < 1) {
              timer.cancel();
            } else {
              timeLeft = timeLeft - 1;
            }
          },
        ),
      );
    }
    // if (widget.isClaimed) {
    //   setState(() {
    //     progress = 1;
    //     status = 'Arrived';
    //   });
    // }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isClaimed) {
      timer?.cancel();
      countdown.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    getFlights();
    if (widget.isClaimed) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => update());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.isClaimed ? 'View Offer' : 'Claim Offer'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            // timer.cancel();
            // countdown.cancel();
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading || isLoadingOther
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
                        'https://firebasestorage.googleapis.com/v0/b/airlines-manager-b7e46.appspot.com/o/f_countryside.jpeg?alt=media&token=b7454368-af7b-4951-af18-7b19c4aff899',
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
                              : '${myRunningFlights[widget.index].departureDes} -> ${myRunningFlights[widget.index].arrivalDes}'),
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
                                  'Flight ID: ${myRunningFlights[widget.index].flightNumber}',
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
                                    ? 'Flight Time: ${myRunningFlights[widget.index].flightTime} minutes'
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
                                  text: 'Required capacity: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.isClaimed
                                          ? myRunningFlights[widget.index]
                                              .minCapacity
                                              .toString()
                                          : allFlights[widget.index]
                                              .minCapacity
                                              .toString(),
                                      style: TextStyle(
                                        color: widget.isClaimed
                                            ? Colors.black
                                            : position == null
                                                ? Colors.red
                                                : allFlights[widget.index]
                                                            .minCapacity >=
                                                        myPlanes[position].seats
                                                    ? Colors.black
                                                    : Colors.red,
                                        fontWeight: widget.isClaimed
                                            ? FontWeight.normal
                                            : position == null
                                                ? FontWeight.bold
                                                : allFlights[widget.index]
                                                            .minCapacity >=
                                                        myPlanes[position].seats
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                      ),
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
                                  text: 'Required range ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.isClaimed
                                          ? myRunningFlights[widget.index]
                                              .range
                                              .toString()
                                          : allFlights[widget.index]
                                              .range
                                              .toString(),
                                      style: TextStyle(
                                        color: widget.isClaimed
                                            ? Colors.black
                                            : position == null
                                                ? Colors.red
                                                : allFlights[widget.index]
                                                            .range >=
                                                        myPlanes[position]
                                                            .distance
                                                    ? Colors.black
                                                    : Colors.red,
                                        fontWeight: widget.isClaimed
                                            ? FontWeight.normal
                                            : position == null
                                                ? FontWeight.bold
                                                : allFlights[widget.index]
                                                            .range >=
                                                        myPlanes[position]
                                                            .distance
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                      ),
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
                                    ? 'Reward: ${myRunningFlights[widget.index].reward} coins'
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
                                  isLoadingOther || isLoading
                                      ? 'Loading...'
                                      : position == null
                                          ? ''
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
                                          : position == null
                                              ? Colors.grey
                                              : myPlanes[position].distance >=
                                                          allFlights[
                                                                  widget.index]
                                                              .range &&
                                                      myPlanes[position]
                                                              .seats >=
                                                          allFlights[
                                                                  widget.index]
                                                              .minCapacity
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.grey),
                                ),
                                onPressed: widget.isClaimed
                                    ? null
                                    : position == null
                                        ? null
                                        : (myPlanes[position].distance >=
                                                    allFlights[widget.index]
                                                        .range &&
                                                myPlanes[position].seats >=
                                                    allFlights[widget.index]
                                                        .minCapacity)
                                            ? () async {
                                                // setState(() {
                                                //   widget.isClaimed = true;
                                                // });
                                                await claimOffer();
                                                Navigator.pop(context);
                                              }
                                            : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (widget.isClaimed)
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
                              child: Text(
                                  myRunningFlights[widget.index].departureId),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10, top: 2),
                              child: Text(
                                  myRunningFlights[widget.index].arrivalId),
                            ),
                          ],
                        ),
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
