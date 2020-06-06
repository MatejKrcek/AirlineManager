import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../models/offer.dart';
import '../models/myFlights.dart';

class KiwiProvider with ChangeNotifier {
  KiwiProvider(this.myRunningFlights, this.allFlights);
  List<MyFlights> myRunningFlights = [];
  List<Offer> allFlights = [];

  void openKiwi() async {
    const url = 'https://kiwi.com';
    if (await canLaunch(url)) {
      await launch(url);
      print('ano');
    } else {
      throw 'Could not launch $url';
    }
  }

  Future getKiwiData(bool isClaimed, int index) async {
    print('loading');
    String _time = DateFormat.yMd().format(DateTime.now()).toString();
    var arr = _time.split('/');
    var _url;
    print(allFlights.length);
    if (isClaimed) {
      _url =
          'https://kiwicom-prod.apigee.net/v2/search?fly_from=${myRunningFlights[index].departureId}&fly_to=${myRunningFlights[index].arrivalId}&date_from=${arr[1]}%2F${arr[0]}%2F${arr[2]}&date_to=${arr[1]}%2F07%2F2020&return_from=02%2F06%2F2020&return_to=02%2F07%2F2020&nights_in_dst_from=1&nights_in_dst_to=14&max_fly_duration=20&flight_type=round&adults=1&selected_cabins=C&mix_with_cabins=M&partner_market=us&max_stopovers=2&vehicle_type=aircraft';
    } else {
      _url =
          'https://kiwicom-prod.apigee.net/v2/search?fly_from=${allFlights[index].departureId}&fly_to=${allFlights[index].arrivalId}&date_from=${arr[1]}%2F${arr[0]}%2F${arr[2]}&date_to=${arr[1]}%2F07%2F2020&return_from=02%2F06%2F2020&return_to=02%2F07%2F2020&nights_in_dst_from=1&nights_in_dst_to=14&max_fly_duration=20&flight_type=round&adults=1&selected_cabins=C&mix_with_cabins=M&partner_market=us&max_stopovers=2&vehicle_type=aircraft';
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
