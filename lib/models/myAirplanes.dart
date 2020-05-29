import 'package:flutter/foundation.dart';

class MyAirplane {
  String id;
  String name;
  int price;
  int seats;
  int distance;
  int speed;
  String imageUrl;
  int totalFlightDistance;
  int totalFlightTime;
  int totalFlights;
  String aircraftIdentity;
  String onFlight; //POZOR BOOL

  MyAirplane({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.seats,
    @required this.speed,
    @required this.distance,
    @required this.imageUrl,
    @required this.totalFlightTime,
    @required this.totalFlightDistance,
    @required this.totalFlights,
    @required this.aircraftIdentity,
    @required this.onFlight,
  });
}
