import 'package:flutter/foundation.dart';

class Airplane {
  String id;
  String name;
  int price;
  int seats;
  int distance;
  int speed;
  String imageUrl;

  Airplane({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.seats,
    @required this.speed,
    @required this.distance,
    @required this.imageUrl,
  });
}
