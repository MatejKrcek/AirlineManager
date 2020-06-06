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
  String departureId;
  String arrivalId;
  String arrivalTime;
  String category;
  String note;
  String imageUrl;

  Offer({
    this.id,
    this.departureDes,
    this.arrivalDes,
    this.price,
    this.time,
    this.departureTime,
    this.created,
    this.range,
    this.minCapacity,
    this.expiration,
    this.departureId,
    this.arrivalId,
    this.note,
    this.arrivalTime,
    this.category,
    this.imageUrl,
  });
}
