import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class MyPlanesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProvider>(context, listen: false).getPlanes(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              child: const CircularProgressIndicator(),
            ),
          );
        } else {
          return Consumer<UserProvider>(
            builder: (ctx, user, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "My ",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: "Airplanes",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    width: double.infinity,
                    height: user.myPlanes.length == 0 ? 50 : 230,
                    child: user.myPlanes.length == 0
                        ? Center(
                            child: const Text(
                                'Hey! You have no airplane! Visit shop!'),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: user.countPlanes + 1,
                            itemBuilder: (context, index) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 170,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          user.myPlanes[index].imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      user.myPlanes[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Range: ${user.myPlanes[index].distance.toString()} km',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Seats: ${user.myPlanes[index].seats.toString()}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            DateTime.parse(user.myPlanes[index]
                                                        .arrivalTime)
                                                    .isAfter(DateTime.now())
                                                ? 'On Flight'
                                                : 'Available',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: DateTime.parse(user
                                                          .myPlanes[index]
                                                          .arrivalTime)
                                                      .isAfter(DateTime.now())
                                                  ? Colors.red
                                                  : Colors.green,
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
