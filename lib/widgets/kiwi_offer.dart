import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/kiwi_provider.dart';
import '../models/offer.dart';
import '../providers/offers_provider.dart';

class KiwiOffer extends StatelessWidget {
  const KiwiOffer({
    Key key,
    @required this.index,
    this.isClaimed,
  }) : super(key: key);

  final int index;
  final bool isClaimed;

  @override
  Widget build(BuildContext context) {
    // final kiwi = Provider.of<OffersProvider>(context, listen: false);
    // final call = kiwi.getFlights();
    // final List<Offer> allFlights = kiwi.allFlights;
    return FutureBuilder(
      future: Provider.of<OffersProvider>(context, listen: false)
          .getFlights(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              child: const CircularProgressIndicator(),
            ),
          );
        } else {
          print('ano');
          // final List allFlights = Provider.of<OffersProvider>(context, listen: false).allFlights;
          print(Provider.of<OffersProvider>(context, listen: false).allFlights.length);
          return Consumer<OffersProvider>(
            builder: (ctx, kiwi, _) => Container(
              child: Card(
                color: Color.fromRGBO(236, 248, 247, 1),
                elevation: 5,
                child: GestureDetector(
                  onTap: () => Provider.of<KiwiProvider>(context, listen: false)
                      .openKiwi(),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(isClaimed
                            ? 'Visit ${kiwi.myRunningFlights[index].arrivalDes} in real life.'
                            : 'Visit ${kiwi.allFlights[index].arrivalDes} in real life.'),
                        trailing: Container(
                          width: 80,
                          child: Image.asset(
                            'assets/kiwi.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        subtitle: Text('Click to view more.'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15, bottom: 10),
                            child: Text(
                              !isClaimed
                                  ? '${kiwi.allFlights[index].departureDes} -> ${kiwi.allFlights[index].arrivalDes} from \$320 '
                                  : '${kiwi.myRunningFlights[index].departureDes} -> ${kiwi.myRunningFlights[index].arrivalDes} from \$320',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
