import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/app_drawer.dart';
import '../models/user.dart';
import '../models/myAirplanes.dart';
import '../models/myFlights.dart';
import '../models/offer.dart';
import '../screens/auth_screen.dart';

class MainOverviewScreen extends StatefulWidget {
  @override
  _MainOverviewScreenState createState() => _MainOverviewScreenState();
}

class _MainOverviewScreenState extends State<MainOverviewScreen> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<User> user = [];
  List<MyFlights> myFlights = [];
  List<MyAirplane> myPlanes = [];
  List<MyFlights> myActiveFlights = [];
  List<Offer> offers = [];
  int countPlanes = 0;
  int countFlights = 0;
  bool isLoadingOther = false;

  Future getData() async {
    print(User.uid);

    if (User.uid == null) {
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData =
          convert.jsonDecode(prefs.getString('data')) as Map<String, Object>;
      final id = extractedUserData['id'];
      print(id);

      if (!prefs.containsKey('data') ||
          extractedUserData == null ||
          id == null) {
        print('oops');
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
        });
      } else {
        setState(() {
          User.uid = id;
        });
      }
    }

    setState(() {
      isLoading = true;
      countPlanes = 0;
      countFlights = 0;
      myFlights = [];
      myPlanes = [];
      myActiveFlights = [];
    });

    var url2 =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=persons&personId=${User.uid}';

    try {
      var response = await http.get(url2);

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
              arrivalTime: airplanes[item]['arrivalTime'],
            ),
          ];
          myPlanes.add(preps[0]);
        }
        countPlanes = myPlanes.length - 1;
        myPlanes.sort((a, b) => a.name.compareTo(b.name));

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
            myFlights.add(prepsFlights[0]);

            if (DateTime.parse(myFlights[i].arrivalTime)
                .isAfter(DateTime.now())) {
              print('future');
              myActiveFlights.add(myFlights[i]);
              myFlights[0].onAir = true;
            } else {
              myFlights[0].onAir = false;
              //myActiveFlights.removeAt(0);
              print('done');
            }
            i++;
          }
          // print(myFlights[countFlights].departureDes);
          countFlights = myFlights.length - 1;
          // print(myFlights[countFlights].departureDes);
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
            // aircrafts: MyAirplane.add(),
            // flights: myFlights[0],
            created: map['dateCreation'],
            login: map['dateLogin'],
          ),
        ];
        user.add(newUser[0]);
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
    getData();
    // getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
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
                text: "Airline ",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              TextSpan(
                text: "Manager",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => getData(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(isLoading
                          ? 'Loading...'
                          : '${user[0].username}, CEO, Kiwi Airlines'),
                      trailing: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(isLoading
                          ? 'Loading...'
                          : 'Coins: ${user[0].coins.toString()}'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Active ",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: "Flight Offers",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 0,
                      ),
                      width: double.infinity,
                      height: myActiveFlights.length == 0 ? 80 : 200,
                      child: !isLoading
                          ? myActiveFlights.length != 0
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: myActiveFlights.length,
                                  itemBuilder: (context, index) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 170,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                '',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            isLoading
                                                ? 'Loading...'
                                                : '${myActiveFlights[index].departureDes} -> ${myActiveFlights[index].arrivalDes}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            isLoading
                                                ? 'Loading...'
                                                : 'Arrive at: ${DateFormat.MMMMd().add_Hm().format(DateTime.parse(myActiveFlights[index].arrivalTime).add(Duration(hours: 2)))}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .color
                                                    .withOpacity(0.7)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Hey! You have no active offer!'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      RaisedButton(
                                        child: Text('Claim Offer'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  '/offers-screen');
                                        },
                                        color: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "My ",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: "Airplanes",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 0,
                      ),
                      width: double.infinity,
                      height: myPlanes.length == 0 ? 50 : 230,
                      child: myPlanes.length == 0
                          ? Center(
                              child: Text(
                                  'Hey! You have no airplane! Visit shop!'),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: countPlanes + 1,
                              itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: 170,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            myPlanes[index].imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        isLoading
                                            ? 'Loading...'
                                            : myPlanes[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              isLoading
                                                  ? 'Loading...'
                                                  : 'Range: ${myPlanes[index].distance.toString()} km',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              isLoading
                                                  ? 'Loading...'
                                                  : 'Seats: ${myPlanes[index].seats.toString()}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              isLoading
                                                  ? 'Loading...'
                                                  : DateTime.parse(
                                                              myPlanes[index]
                                                                  .arrivalTime)
                                                          .isAfter(
                                                              DateTime.now())
                                                      ? 'On Flight'
                                                      : 'Available',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: DateTime.parse(
                                                            myPlanes[index]
                                                                .arrivalTime)
                                                        .isAfter(DateTime.now())
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
      ),
    );
  }
}
