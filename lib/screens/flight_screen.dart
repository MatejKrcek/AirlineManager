import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class FlightScreen extends StatefulWidget {
  final String id;
  final String arrivalDes;
  final String departureDes;
  final int price;
  final int time;

  FlightScreen(
    this.id,
    this.arrivalDes,
    this.departureDes,
    this.price,
    this.time,
  );

  @override
  _FlightScreenState createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  double spinnerValue = 0;
  double prog = 0;

  Timer timer;
  Timer countdown;
  double timeLeft;
  final oneSec = const Duration(seconds: 1);

  var isLoaded = false;
  String status = 'Departuring';

  double top;
  double right;
  double width;
  double height;

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

  void loader() {
    timeLeft = widget.time.toDouble() * 60;
    prog = coordinates / timeLeft;
    // print(prog);

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

  void update() {
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

    if (widget.arrivalDes == 'Kosice') {
      coordinates = cooordKos;
      top = positionTopKos;
      right = positionRightKos;
      width = widthKos;
      height = heightKos;
    }
    if (widget.arrivalDes == 'Brno') {
      coordinates = coordBrn;
      top = positionTopBrn;
      right = positionRightBrn;
      width = widthBrn;
      height = heightBrn;
    }

    loader();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => update());
  }

  @override
  void dispose() {
    timer?.cancel();
    countdown.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              title: Text('${widget.departureDes} -> ${widget.arrivalDes}'),
              subtitle: Text('Status: $status'),
              trailing: Text(isLoaded == false
                  ? 'Time to arrival: ${timeLeft.toInt()} seconds'
                  : 'Arrived'),
            ),
          ),
          Stack(
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
          ),
          SizedBox(
            height: 10,
          ),
          // OutlineButton(
          //   splashColor: Colors.white,
          //   color: Colors.white,
          //   onPressed: () {},
          //   shape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          //   highlightElevation: 0,
          //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Icon(Icons.info_outline),
          //         Padding(
          //           padding: const EdgeInsets.only(left: 10),
          //           child: Text(
          //             'More About the Flight',
          //             style: TextStyle(),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
