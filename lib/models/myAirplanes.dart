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
  String onFlight;
  String arrivalTime;

  MyAirplane({
    this.id,
    this.name,
    this.price,
    this.seats,
    this.speed,
    this.distance,
    this.imageUrl,
    this.totalFlightTime,
    this.totalFlightDistance,
    this.totalFlights,
    this.aircraftIdentity,
    this.onFlight,
    this.arrivalTime,
  });
}
