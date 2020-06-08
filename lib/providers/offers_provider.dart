import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/offer.dart';
import '../models/myFlights.dart';
import '../models/myAirplanes.dart';
import '../screens/select_plane_screen.dart';

class OffersProvider with ChangeNotifier {
  OffersProvider(this.myRunningFlights, this.myPlanes, this._userId);
  List<MyFlights> myRunningFlights = [];
  List<MyAirplane> myPlanes = [];
  final String _userId;
  List<Offer> _allFlights = [];

  List<Offer> get allFlights {
    return [..._allFlights];
  }

  Future claimOffer(int position, int index) async {
    if (position == null) {
      return;
    }
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/claimFlight?personId=$_userId&flightIdentity=${_allFlights[index].id}&myAircraftsId=${myPlanes[position].id}';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        print('claimed');
        notifyListeners();
        return;
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  Future getFlights() async {
    _allFlights = [];

    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=flights';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> _map = convert.jsonDecode(response.body);

        if (_map == null) {
          return;
        }

        for (var item in _map.keys) {
          final List<Offer> _flightList = [
            Offer(
              id: item,
              departureDes: _map[item]['departureDes'],
              arrivalDes: _map[item]['arrivalDes'],
              departureTime: _map[item]['departureTime'],
              expiration: _map[item]['expiration'],
              range: _map[item]['range'],
              time: _map[item]['flightTime'],
              price: _map[item]['reward'],
              created: _map[item]['created'],
              minCapacity: _map[item]['minCapacity'],
            ),
          ];
          _allFlights.add(_flightList[0]);
        }
        // notifyListeners();
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

}
