import 'package:flutter/material.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/offer.dart';
import '../models/myFlights.dart';

class FlightScreen extends StatefulWidget {
  final bool isMyOffer;
  final int index;

  FlightScreen(
    this.isMyOffer,
    this.index,
  );

  @override
  _FlightScreenState createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  DateTime arrivalTime;
  Duration difference = Duration(seconds: 0);
  double spinnerValue = 0;
  double prog = 0;

  int reward;

  Timer timer;
  Timer countdown;
  double timeLeft = 0;
  final oneSec = const Duration(seconds: 1);

  var isLoaded = false;
  String status = 'Departuring';

  bool map = false;
  double top = 0;
  double right = 0;
  double width = 0;
  double height = 0;

  double positionTopBrn = 97;
  double positionRightBrn = 170;
  double widthBrn = 125;
  double heightBrn = 100;
  double positionTopKos = 97;
  double positionRightKos = 50;
  double widthKos = 370;
  double heightKos = 125;

  double coordinates;
  double coordBrn = 0.223333;
  double cooordKos = 0.253333;

  List<Offer> myFlights = [];
  List<MyFlights> myActiveFlights = [];
  int countFlights = 0;
  bool isLoading = false;

  Future getFlights() async {
    setState(() {
      myFlights = [];
      isLoading = true;
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
          setState(() {
            myFlights.add(flightList[0]);
          });
        }
        setState(() {
          isLoading = false;
        });
        print(myFlights[widget.index].arrivalDes);
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

  Future getMyFlights() async {
    setState(() {
      isLoading = true;
      myActiveFlights = [];
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
            ),
          ];
          myActiveFlights.add(prepsFlights[0]);
        }
        // print(myFlights[countFlights].departureDes);

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

  void loader() {
    if (!isLoading) {
      if (widget.isMyOffer) {
        if (myActiveFlights[widget.index].departureTime == 'DEPARTURE TIME') {
          Navigator.of(context).pushReplacementNamed('/offers-screen');
        } else {
          DateTime timeNow = DateTime.now();
          arrivalTime = timeNow.add(Duration(
              seconds:
                  (myActiveFlights[widget.index].flightTime * 60).toInt()));
          difference = arrivalTime.difference(DateTime.now());
          print(difference);
          // timeLeft = timeNow - DateTime.parse(myActiveFlights[widget.index].departureTime);
        }

        print('myOffer');
        if (map) {
          print('mapa');
        }
        // difference = arrivalTime.difference(DateTime.now());
        // print(difference);
        // timeLeft = difference.inSeconds.toDouble();

        // setState(() {
        //   spinnerValue = prog * timeLeft;
        // });

        // print(spinnerValue);
      } else {
        //ACCEPT OFFER
        print('not my offer');
        if (myActiveFlights[widget.index].departureTime == 'DEPARTURE TIME') {
          Navigator.of(context).pushReplacementNamed('/offers-screen');
        } else {
          DateTime timeNow = DateTime.now();
          arrivalTime = timeNow.add(Duration(
              seconds:
                  (myActiveFlights[widget.index].flightTime * 60).toInt()));
          difference = arrivalTime.difference(DateTime.now());
          print(difference);
          // timeLeft = timeNow - DateTime.parse(myActiveFlights[widget.index].departureTime);
        }
        //timeLeft = myFlights[widget.index].time.toDouble() * 60;
        print(myFlights.length);
        // prog = coordinates / timeLeft;
        // print(prog);
        // arrivalTime = DateTime.now().add(Duration(seconds: (widget.time * 60)));
        // print(arrivalTime);

      }

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
  }

  void update() {
    //vola se kazdou sekundu
    setState(() {
      spinnerValue = spinnerValue + prog;
    });
    // print(spinnerValue);

    if (spinnerValue > (coordinates / 100)) {
      setState(() {
        status = 'On Air';
      });
    }

    if (spinnerValue > (coordinates * 95)) {
      setState(() {
        status = 'Landing';
      });
    }

    if (spinnerValue > coordinates) {
      isLoaded = true;
      setState(() {
        status = 'Arrived';
      });
      timer.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isMyOffer) {
      getMyFlights();
      print('true');
      print(widget.index);
    } else {
      getFlights();
      print('false');
    }

    map = false;

    if (myActiveFlights.length - 1 >= widget.index) {
      for (var i = 0; i < myActiveFlights.length - 1; i++) {
        if (myActiveFlights[myActiveFlights.length - 1].arrivalDes ==
            'Kosice') {
          map = true;
          coordinates = cooordKos;
          top = positionTopKos;
          right = positionRightKos;
          width = widthKos;
          height = heightKos;
        }
        if (myActiveFlights[myActiveFlights.length - 1].arrivalDes == 'Brno') {
          map = true;
          coordinates = coordBrn;
          top = positionTopBrn;
          right = positionRightBrn;
          width = widthBrn;
          height = heightBrn;
        }
      }
    }

    loader();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => update());
  }

  @override
  void dispose() {
    // timer?.cancel();
    // countdown.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/offers-screen');
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              title: Text(!isLoading
                  ? (widget.isMyOffer)
                      ? '${myActiveFlights[widget.index].departureDes} -> ${myActiveFlights[widget.index].arrivalDes}'
                      : '${myFlights[widget.index].departureDes} -> ${myFlights[widget.index].arrivalDes}'
                  : 'Loading...'),
              subtitle: Text('Status: $status'),
              trailing: Text(isLoaded == false
                  ? 'Time to arrival: ${timeLeft.toInt()} seconds'
                  : 'Arrived'),
            ),
          ),
          map
              ? Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1), color: Colors.grey),
                      child: Image.asset(
                        'assets/map.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: top,
                      right: right,
                      child: SizedBox(
                        height: height,
                        width: width,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          strokeWidth: 5,
                          value: spinnerValue,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                    )
                  ],
                )
              : Text('AHoj'),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
