import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../widgets/app_drawer.dart';
import '../models/offer.dart';
import '../widgets/offers.dart';
import '../models/myFlights.dart';
import '../models/user.dart';

enum FilterOptions {
  Favorites,
  All,
}

class OffersOverviewScreen extends StatefulWidget {
  static const routeName = '/offers-screen';

  // final String id;
  // final bool isRunning;
  // final DateTime arrivalTime;

  // OffersOverviewScreen(this.id, this.isRunning, this.arrivalTime);

  @override
  _OffersOverviewScreenState createState() => _OffersOverviewScreenState();
}

class _OffersOverviewScreenState extends State<OffersOverviewScreen> {
  List<Offer> myFlights = [];
  List<MyFlights> myActiveFlights = [];
  bool isLoading = false;
  bool isLoadingOther = false;
  List<MyFlights> myRunningFlights = [];
  var _showOnFlight = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future getFlights() async {
    setState(() {
      isLoadingOther = true;
      myFlights = [];
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
            myFlights.add(flightList[0]);
          });
        }
        print(myFlights.length);
        print('2');
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

  Future getMyFlights() async {
    setState(() {
      isLoading = true;
      myActiveFlights = [];
      myActiveFlights = [];
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

        if (map['flights'] != null) {
          var flights = map['flights'];
          int i = 0;
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
              ),
            ];

            myActiveFlights.add(prepsFlights[0]);

            if (DateTime.parse(myActiveFlights[i].arrivalTime)
                .isAfter(DateTime.now())) {
              myActiveFlights[0].onAir = true;
              myRunningFlights.add(myActiveFlights[i]);
            } else {
              myActiveFlights[0].onAir = false;
              //myActiveFlights.removeAt(0);
            }
            i++;
          }
        }
        print('LENGHT');
        print(myRunningFlights.length);
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

  @override
  void initState() {
    super.initState();
    // dates();
    getFlights();
    getMyFlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
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
                text: "Flight ",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              TextSpan(
                text: "Offers",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            tooltip: 'Show Filters',
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnFlight = true;
                } else {
                  _showOnFlight = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only On Flight'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All Available'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: !isLoading || !isLoadingOther
          ? RefreshIndicator(
              onRefresh: () => getMyFlights(),
              child: Offers(
                  myFlights, myActiveFlights, _showOnFlight, myRunningFlights))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
