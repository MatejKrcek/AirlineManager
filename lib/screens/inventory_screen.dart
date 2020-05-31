import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../widgets/app_drawer.dart';
import '../models/airplane.dart';
import './airplane_detail_screen.dart';
import '../models/myAirplanes.dart';
import '../models/user.dart';

class InventoryScreen extends StatefulWidget {
  static const routeName = '/inventory-screen';

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool isLoading = false;
  final List<User> user = [];
  List<MyAirplane> myPlanes = [];
  int countPlanes = 0;

  Future getData() async {
    setState(() {
      isLoading = true;
      countPlanes = 0;
      myPlanes = [];
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
        countPlanes = myPlanes.length - 1;
        print(myPlanes.length);

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
        print(countPlanes);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Inventory'),
      ),
      drawer: AppDrawer(),
      body: Container(
        margin: EdgeInsets.all(10),
        child: isLoading
            ? const Center(
                child: const CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: myPlanes.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AirplaneDetailScreen(
                          index,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GridTile(
                      child: Image.network(
                        myPlanes[index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                      footer: GridTileBar(
                        backgroundColor: Colors.black87,
                        title: Text(
                          myPlanes[index].name,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
