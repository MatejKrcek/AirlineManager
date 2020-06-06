import 'package:flutter/foundation.dart';

class MyFlights {
  String id;
  String departureDes;
  String arrivalDes;
  String aircraft;
  String departureTime;
  bool onAir;
  String flightNumber;
  int reward;
  int flightTime;
  String arrivalTime;
  String arrivalId;
  String departureId;
  int range;
  int minCapacity;
  String category;
  int expiration;
  String note;
  String imageUrl;

  MyFlights({
    this.id,
    this.departureDes,
    this.arrivalDes,
    this.aircraft,
    this.flightNumber,
    this.onAir,
    this.departureTime,
    this.reward,
    this.flightTime,
    this.arrivalTime,
    this.range,
    this.arrivalId,
    this.departureId,
    this.minCapacity,
    this.imageUrl,
    this.category,
    this.note,
    this.expiration,
  });
}
