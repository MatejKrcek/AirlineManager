import 'package:flutter/foundation.dart';

class Offer {
  String id;
  String departureDes;
  String arrivalDes;
  int expiration;
  int range;
  String created;
  int minCapacity;
  int price;
  String departureTime;
  int time;

  Offer({
    @required this.id,
    @required this.departureDes,
    @required this.arrivalDes,
    @required this.price,
    @required this.time,
    @required this.departureTime,
    @required this.created,
    @required this.range,
    @required this.minCapacity,
    @required this.expiration,
  });
}
