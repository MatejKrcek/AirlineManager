import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class MyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProvider>(context, listen: false).getUser(),
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
            builder: (ctx, user, _) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('${user.user[0].username}, CEO, Kiwi Airlines'),
                    trailing: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Coins: ${user.user[0].coins.toString()}'),
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
