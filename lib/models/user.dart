import 'package:flutter/foundation.dart';

import './airplane.dart';

class User {
  String username;
  String airlineName;
  int coins;

  User({
    @required this.username,
    @required this.airlineName,
    @required this.coins,
  });
}
