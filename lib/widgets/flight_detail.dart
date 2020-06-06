import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/offers_provider.dart';
import '../screens/claim_offer_screen.dart';

class FlightDetail extends StatelessWidget {
  const FlightDetail({
    Key key,
    @required this.widget,
    @required this.position,
    @required this.navigate,
  }) : super(key: key);

  final ClaimOfferScreen widget;
  final int position;
  final void Function() navigate;

  @override
  Widget build(BuildContext context) {
    return Consumer<OffersProvider>(
      builder: (ctx, offers, _) => Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(!widget.isClaimed
                  ? '${offers.allFlights[widget.index].departureDes} -> ${offers.allFlights[widget.index].arrivalDes}'
                  : '${offers.myRunningFlights[widget.index].departureDes} -> ${offers.myRunningFlights[widget.index].arrivalDes}'),
            ),
            if (widget.isClaimed)
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      bottom: 5,
                    ),
                    child: Text(
                      'Flight ID: ${offers.myRunningFlights[widget.index].flightNumber}',
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
                    widget.isClaimed
                        ? 'Flight Time: ${offers.myRunningFlights[widget.index].flightTime} minutes'
                        : 'Flight Time: ${offers.allFlights[widget.index].time} minutes',
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
                  child: RichText(
                    text: TextSpan(
                      text: 'Required capacity: ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.isClaimed
                              ? offers
                                  .myRunningFlights[widget.index].minCapacity
                                  .toString()
                              : offers.allFlights[widget.index].minCapacity
                                  .toString(),
                          style: TextStyle(
                            color: widget.isClaimed
                                ? Colors.black
                                : position == null
                                    ? Colors.red
                                    : offers.allFlights[widget.index]
                                                .minCapacity >=
                                            offers.myPlanes[position].seats
                                        ? Colors.black
                                        : Colors.red,
                            fontWeight: widget.isClaimed
                                ? FontWeight.normal
                                : position == null
                                    ? FontWeight.bold
                                    : offers.allFlights[widget.index]
                                                .minCapacity >=
                                            offers.myPlanes[position].seats
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' seats',
                          style: TextStyle(fontWeight: FontWeight.normal),
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
                  child: RichText(
                    text: TextSpan(
                      text: 'Required range ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.isClaimed
                              ? offers.myRunningFlights[widget.index].range
                                  .toString()
                              : offers.allFlights[widget.index].range
                                  .toString(),
                          style: TextStyle(
                            color: widget.isClaimed
                                ? Colors.black
                                : position == null
                                    ? Colors.red
                                    : offers.allFlights[widget.index].range >=
                                            offers.myPlanes[position].distance
                                        ? Colors.black
                                        : Colors.red,
                            fontWeight: widget.isClaimed
                                ? FontWeight.normal
                                : position == null
                                    ? FontWeight.bold
                                    : offers.allFlights[widget.index].range >=
                                            offers.myPlanes[position].distance
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' km',
                          style: TextStyle(fontWeight: FontWeight.normal),
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
                    widget.isClaimed
                        ? 'Reward: ${offers.myRunningFlights[widget.index].reward} coins'
                        : 'Reward: ${offers.allFlights[widget.index].price} coins',
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
            if (!widget.isClaimed)
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
                          color: widget.isClaimed
                              ? Colors.grey
                              : Theme.of(context).primaryColor),
                    ),
                    onPressed: widget.isClaimed 
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
                          color: widget.isClaimed
                              ? Colors.grey
                              : position == null
                                  ? Colors.grey
                                  : offers.myPlanes[position].distance >=
                                              offers.allFlights[widget.index]
                                                  .range &&
                                          offers.myPlanes[position].seats >=
                                              offers.allFlights[widget.index]
                                                  .minCapacity
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey),
                    ),
                    onPressed: widget.isClaimed
                        ? null
                        : position == null
                            ? null
                            : (offers.myPlanes[position].distance >=
                                        offers.allFlights[widget.index].range &&
                                    offers.myPlanes[position].seats >=
                                        offers.allFlights[widget.index]
                                            .minCapacity)
                                ? () async {
                                    await Provider.of<OffersProvider>(context,
                                            listen: false)
                                        .claimOffer(position, widget.index);
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
}
