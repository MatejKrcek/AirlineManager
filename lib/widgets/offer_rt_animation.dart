import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/offers_provider.dart';

class FlightAnimation extends StatelessWidget {
  const FlightAnimation({
    Key key,
    @required this.progress,
    @required this.index,
    @required this.status,
  }) : super(key: key);

  final double progress;
  final int index;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Consumer<OffersProvider>(
      builder: (ctx, offers, _) => Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              top: 20,
              right: 10,
              left: 10,
            ),
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              value: progress,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10, top: 2),
                child: Text(offers.myRunningFlights[index].departureId),
              ),
              Container(
                margin: EdgeInsets.only(right: 10, top: 2),
                child: Text(offers.myRunningFlights[index].arrivalId),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text('Status: $status'),
          ),
        ],
      ),
    );
  }
}
