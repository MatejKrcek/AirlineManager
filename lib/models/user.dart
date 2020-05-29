import 'package:flutter/foundation.dart';

import './myAirplanes.dart';
import './myFlights.dart';

class User {
  String id;
  String username;
  String airlineName;
  int coins;
  int gems;
  int pilotRank;
  int gameLevel;
  String profilePictureUrl;
  String created;
  String login;
  int totalFlightTime;
  int totalFlightDistance;
  MyAirplane aircrafts;
  MyFlights flights;

  User({
    @required this.id,
    @required this.username,
    @required this.airlineName,
    @required this.coins,
    @required this.gems,
    @required this.pilotRank,
    @required this.gameLevel,
    @required this.profilePictureUrl,
    @required this.created,
    @required this.login,
    @required this.totalFlightDistance,
    @required this.totalFlightTime,
    this.aircrafts,
    this.flights,
  });

  static fromJson(decode) {}
}
