import 'package:flutter/foundation.dart';

class Airplane {
  String name;
  int price;
  int seats;
  int distance;
  String imageUrl;
  bool onFlight = false; 

  Airplane({
    @required this.name,
    @required this.price,
    @required this.seats,
    @required this.distance,
    @required this.imageUrl,
    @required this.onFlight,
  });
}
