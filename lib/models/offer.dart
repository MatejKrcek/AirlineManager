import 'package:flutter/foundation.dart';

class Offer {
  String id;
  String departureDes;
  String arrivalDes;
  // int expiration;
  // int range;
  // int created;
  // int minCapacity;
  int price;
  int time;
  bool isRunning = false;

  Offer({
    @required this.id,
    @required this.departureDes,
    @required this.arrivalDes,
    @required this.price,
    @required this.time,
    @required this.isRunning,
  });
}
