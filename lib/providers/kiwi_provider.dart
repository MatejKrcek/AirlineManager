import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../models/offer.dart';
import '../models/myFlights.dart';

class KiwiProvider with ChangeNotifier {
  KiwiProvider(this.userId);
  final String userId;

  List<MyFlights> _myActiveFlights = [];
  List<Offer> _allFlights = [];
  List<MyFlights> _myFlights = [];
  int countFlights = 0;

  List<MyFlights> get myRunningFlights {
    return [..._myActiveFlights];
  }

  List<Offer> get allFlights {
    return [..._allFlights];
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

  Future<void> getMyFlights() async {
    _myFlights = [];
    countFlights = 0;
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=persons&personId=$userId';

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

  void openKiwi() async {
    const url = 'https://kiwi.com';
    if (await canLaunch(url)) {
      await launch(url);
      print('anoano');
    } else {
      throw 'Could not launch $url';
    }
  }

  Future getKiwiData(bool isClaimed, int index) async {
    print('loading');
    String _time = DateFormat.yMd().format(DateTime.now()).toString();
    var arr = _time.split('/');
    var _url;
    print(_allFlights.length);
    if (isClaimed) {
      _url =
          'https://kiwicom-prod.apigee.net/v2/search?fly_from=${myRunningFlights[index].departureId}&fly_to=${myRunningFlights[index].arrivalId}&date_from=${arr[1]}%2F${arr[0]}%2F${arr[2]}&date_to=${arr[1]}%2F07%2F2020&return_from=02%2F06%2F2020&return_to=02%2F07%2F2020&nights_in_dst_from=1&nights_in_dst_to=14&max_fly_duration=20&flight_type=round&adults=1&selected_cabins=C&mix_with_cabins=M&partner_market=us&max_stopovers=2&vehicle_type=aircraft';
    } else {
      _url =
          'https://kiwicom-prod.apigee.net/v2/search?fly_from=${_allFlights[index].departureId}&fly_to=${_allFlights[index].arrivalId}&date_from=${arr[1]}%2F${arr[0]}%2F${arr[2]}&date_to=${arr[1]}%2F07%2F2020&return_from=02%2F06%2F2020&return_to=02%2F07%2F2020&nights_in_dst_from=1&nights_in_dst_to=14&max_fly_duration=20&flight_type=round&adults=1&selected_cabins=C&mix_with_cabins=M&partner_market=us&max_stopovers=2&vehicle_type=aircraft';
    }
    try {
      Map<String, String> _head = {
        'apikey': 'yd0zaA0gsNHmeHljmKGEikKQTwgS2S5d'
      };

      var response = await http.get(_url, headers: _head);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);
        if (map == null) {
          return;
        }
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }
}
