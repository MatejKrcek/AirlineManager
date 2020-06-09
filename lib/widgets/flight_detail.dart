import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/offers_provider.dart';
import 'package:intl/intl.dart';

class FlightDetail extends StatelessWidget {
  FlightDetail(
    this.index,
    this.isClaimed,
    this.position,
    this.navigate,
  );

  final int index;
  final int position;
  final bool isClaimed;
  final void Function() navigate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isClaimed
          ? Provider.of<OffersProvider>(context, listen: false).getMyFlights()
          : Provider.of<OffersProvider>(context, listen: false).getFlights(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              child: const CircularProgressIndicator(),
            ),
          );
        } else {
          return Consumer<OffersProvider>(
            builder: (ctx, offers, _) => Card(
              elevation: 5,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(!isClaimed
                        ? '${offers.allFlights[index].departureDes} -> ${offers.allFlights[index].arrivalDes}'
                        : '${offers.myActiveFlights[index].departureDes} -> ${offers.myActiveFlights[index].arrivalDes}'),
                  ),
                  if (isClaimed)
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            bottom: 5,
                          ),
                          child: Text(
                            'Flight ID: ${offers.myActiveFlights[index].flightNumber}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          bottom: 5,
                        ),
                        child: Text(
                          isClaimed
                              ? 'Flight Time: ${offers.myActiveFlights[index].flightTime} minutes'
                              : 'Flight Time: ${offers.allFlights[index].time} minutes',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isClaimed)
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            bottom: 5,
                          ),
                          child: Text(
                            'Arrive at: ${DateFormat.MMMMd().add_Hm().format(DateTime.parse(offers.myActiveFlights[index].arrivalTime).add(Duration(hours: 2)))}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!isClaimed)
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            bottom: 5,
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Required capacity: ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: isClaimed
                                      ? offers
                                          .myActiveFlights[index].minCapacity
                                          .toString()
                                      : offers.allFlights[index].minCapacity
                                          .toString(),
                                  style: TextStyle(
                                    color: isClaimed
                                        ? Colors.black
                                        : position == null
                                            ? Colors.red
                                            : offers.allFlights[index]
                                                        .minCapacity >=
                                                    offers.myPlanes[position]
                                                        .seats
                                                ? Colors.black
                                                : Colors.red,
                                    fontWeight: isClaimed
                                        ? FontWeight.normal
                                        : position == null
                                            ? FontWeight.bold
                                            : offers.allFlights[index]
                                                        .minCapacity >=
                                                    offers.myPlanes[position]
                                                        .seats
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' seats',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!isClaimed)
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            bottom: 5,
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Required range ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: isClaimed
                                      ? offers.myActiveFlights[index].range
                                          .toString()
                                      : offers.allFlights[index].range
                                          .toString(),
                                  style: TextStyle(
                                    color: isClaimed
                                        ? Colors.black
                                        : position == null
                                            ? Colors.red
                                            : offers.allFlights[index].range >=
                                                    offers.myPlanes[position]
                                                        .distance
                                                ? Colors.black
                                                : Colors.red,
                                    fontWeight: isClaimed
                                        ? FontWeight.normal
                                        : position == null
                                            ? FontWeight.bold
                                            : offers.allFlights[index].range >=
                                                    offers.myPlanes[position]
                                                        .distance
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' km',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          bottom: 5,
                        ),
                        child: Text(
                          isClaimed
                              ? 'Reward: ${offers.myActiveFlights[index].reward} coins'
                              : 'Reward: ${offers.allFlights[index].price} coins',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (!isClaimed)
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            bottom: 5,
                          ),
                          child: Text(
                            position == null
                                ? ''
                                : 'Selected Airplane: ${offers.myPlanes[position].name}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: FlatButton(
                          child: Text(
                            'SELECT AIRPLANE',
                            style: TextStyle(
                                color: isClaimed
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor),
                          ),
                          onPressed: isClaimed
                              ? null
                              : () {
                                  // Provider.of<OffersProvider>(context, listen: false).navigate(widget.index, position, context);
                                  navigate();
                                },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: FlatButton(
                          child: Text(
                            'CLAIM',
                            style: TextStyle(
                                color: isClaimed
                                    ? Colors.grey
                                    : position == null
                                        ? Colors.grey
                                        : offers.myPlanes[position].distance >=
                                                    offers.allFlights[index]
                                                        .range &&
                                                offers.myPlanes[position]
                                                        .seats >=
                                                    offers.allFlights[index]
                                                        .minCapacity
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey),
                          ),
                          onPressed: isClaimed
                              ? null
                              : position == null
                                  ? null
                                  : (offers.myPlanes[position].distance >=
                                              offers.allFlights[index].range &&
                                          offers.myPlanes[position].seats >=
                                              offers.allFlights[index]
                                                  .minCapacity)
                                      ? () async {
                                          await Provider.of<OffersProvider>(
                                                  context,
                                                  listen: false)
                                              .claimOffer(position, index);
                                          Navigator.pop(context);
                                        }
                                      : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
