import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import './select_plane_screen.dart';
import '../widgets/flight_detail.dart';
import '../widgets/offer_rt_animation.dart';
import '../widgets/kiwi_offer.dart';
import '../providers/offers_provider.dart';

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
  int position;
  double progToAd = 0;
  double progress = 0;
  String status = 'Departuring';
  Timer timer;
  Timer countdown;
  final oneSec = const Duration(seconds: 1);

  void _navigate() async {
    final data = Provider.of<OffersProvider>(context, listen: false);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ChooseAirplane(data.myPlanes, data.allFlights, widget.index)),
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
    final data = Provider.of<OffersProvider>(context, listen: true);

    if (data.myRunningFlights[widget.index].onAir) {
      print('onair');
      DateTime arrival =
          DateTime.parse(data.myRunningFlights[widget.index].arrivalTime);

      Duration difference = arrival.difference(DateTime.now());
      double currentDifference = difference.inSeconds.toDouble();
      double totalDifference =
          data.myRunningFlights[widget.index].flightTime.toDouble() * 60;
      setState(() {
        progToAd = 1 / totalDifference;
        progress = progToAd * (totalDifference - currentDifference);
      });
      // print('prog:');
      print(progToAd);
      print(progress);

      double timeLeft = data.myRunningFlights[widget.index].flightTime.toDouble();
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
    if (widget.isClaimed) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => update());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: widget.isClaimed
            ? RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "View ",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: "Flight",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
              )
            : RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "Claim ",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: "Flight",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
              ),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
              FlightDetail(
                widget: widget,
                position: position,
                navigate: _navigate,
              ),
              SizedBox(
                height: 30,
              ),
              if (widget.isClaimed)
                FlightAnimation(
                    progress: progress, index: widget.index, status: status),
              KiwiOffer(
                index: widget.index,
                isClaimed: widget.isClaimed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
