import 'package:flutter/foundation.dart';

import './myAirplanes.dart';
import './myFlights.dart';

class User {
  static String uid;
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
    this.id,
    this.username,
    this.airlineName,
    this.coins,
    this.gems,
    this.pilotRank,
    this.gameLevel,
    this.profilePictureUrl,
    this.created,
    this.login,
    this.totalFlightDistance,
    this.totalFlightTime,
    this.aircrafts,
    this.flights,
  });
} 
