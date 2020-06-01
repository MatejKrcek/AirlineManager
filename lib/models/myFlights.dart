import 'package:flutter/foundation.dart';

class MyFlights {
  String id;
  String departureDes;
  String arrivalDes;
  String aircraft;
  String departureTime; //POZOR
  bool onAir;
  String flightNumber;
  int reward;
  int flightTime;
  String arrivalTime;
  String arrivalId;
  String departureId;
  int range;
  int minCapacity;

  MyFlights({
    @required this.id,
    @required this.departureDes,
    @required this.arrivalDes,
    @required this.aircraft,
    @required this.flightNumber,
    @required this.onAir,
    @required this.departureTime,
    @required this.reward,
    @required this.flightTime,
    this.arrivalTime,
    this.range,
    this.arrivalId,
    this.departureId,
    this.minCapacity,
  });
}
