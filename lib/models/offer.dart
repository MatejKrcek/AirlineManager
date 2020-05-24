import 'package:flutter/foundation.dart';

class Offer {
  String id;
  String departureDes;
  String arrivalDes;
  int price;
  int time;

  Offer({
    @required this.id,
    @required this.departureDes,
    @required this.arrivalDes,
    @required this.price,
    @required this.time
  });
}
