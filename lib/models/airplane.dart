import 'package:flutter/foundation.dart';

class Airplane {
  String id;
  String name;
  int price;
  int seats;
  int distance;
  int speed;
  String imageUrl;
  String note;

  Airplane({
    this.id,
    this.name,
    this.price,
    this.seats,
    this.speed,
    this.distance,
    this.imageUrl,
    this.note,
  });
}
