import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/offer.dart';
import '../models/myFlights.dart';
import '../models/myAirplanes.dart';

class OffersProvider with ChangeNotifier {
  OffersProvider(this._userId);
  final String _userId;

  List<Offer> _allFlights = [];
  List<MyFlights> _myFlights = [];
  List<MyFlights> _myActiveFlights = [];
  List<MyAirplane> _myPlanes = [];
  int countPlanes = 0;
  int countFlights = 0;

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

  List<MyFlights> get myFlights {
    return [..._myFlights];
  }

  List<MyFlights> get myActiveFlights {
    return [..._myActiveFlights];
  }

  List<MyAirplane> get myPlanes {
    return [..._myPlanes];
  }

  Future<void> getPlanes() async {
    _myPlanes = [];

    countPlanes = 0;
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=persons&personId=$_userId';

    try {
      var _response = await http.get(url);
      if (_response.statusCode == 200) {
        Map<String, dynamic> _map = convert.jsonDecode(_response.body);

        if (_map == null) {
          return;
        }

        var _airplanes = _map['aircrafts'];
        for (var item in _airplanes.keys) {
          List<MyAirplane> _preps = [
            MyAirplane(
              id: item,
              name: _airplanes[item]['name'],
              imageUrl: _airplanes[item]['imageUrl'],
              seats: _airplanes[item]['capacity'],
              price: _airplanes[item]['price'],
              onFlight: _airplanes[item]['onFlight'],
              distance: _airplanes[item]['range'],
              totalFlightDistance: _airplanes[item]['totalDistance'],
              speed: _airplanes[item]['speed'],
              totalFlightTime: _airplanes[item]['totalFlightTime'],
              totalFlights: _airplanes[item]['totalFlights'],
              aircraftIdentity: _airplanes[item]['aircraftIdentity'],
              arrivalTime: _airplanes[item]['arrivalTime'],
            ),
          ];
          _myPlanes.add(_preps[0]);
        }
        countPlanes = _myPlanes.length - 1;
        _myPlanes.sort((a, b) => a.name.compareTo(b.name));

        // notifyListeners();
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> getMyFlights() async {
    _myFlights = [];
    countFlights = 0;
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=persons&personId=$_userId';

    try {
      var _response = await http.get(url);
      if (_response.statusCode == 200) {
        Map<String, dynamic> _map = convert.jsonDecode(_response.body);

        if (_map == null) {
          return;
        }

        if (_map['flights'] != null) {
          _myActiveFlights = [];
          var _flights = _map['flights'];
          int i = 0;
          for (var item in _flights.keys) {
            List<MyFlights> _prepsFlights = [
              MyFlights(
                id: item,
                arrivalDes: _flights[item]['arrivalDes'],
                departureDes: _flights[item]['departureDes'],
                aircraft: _flights[item]['aircraft'],
                departureTime: _flights[item]['departureTime'],
                reward: _flights[item]['reward'],
                onAir: _flights[item]['onAir'],
                flightNumber: _flights[item]['flightNo'],
                flightTime: _flights[item]['flightTime'],
                arrivalTime: _flights[item]['arrivalTime'],
              ),
            ];
            _myFlights.add(_prepsFlights[0]);

            if (DateTime.parse(_myFlights[i].arrivalTime)
                .isAfter(DateTime.now())) {
              print('future');
              _myActiveFlights.add(_myFlights[i]);
              _myFlights[i].onAir = true;
            } else {
              _myFlights[i].onAir = false;
              //myActiveFlights.removeAt(0);
              print('done');
            }
            i++;
          }
          countFlights = _myFlights.length - 1;
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
