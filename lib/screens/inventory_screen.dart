import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import './airplane_detail_screen.dart';
import '../providers/user_provider.dart';

class InventoryScreen extends StatefulWidget {
  static const routeName = '/inventory-screen';

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int countPlanes = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            builder: (ctx, user, _) => Scaffold(
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                    icon: SvgPicture.asset(
                      "assets/svg/menu.svg",
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    }),
                title: RichText(
                  text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "My ",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      TextSpan(
                        text: "Inventory",
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ],
                  ),
                ),
              ),
              drawer: AppDrawer(),
              body: Container(
                margin: EdgeInsets.all(10),
                child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: user.myPlanes.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AirplaneDetailScreen(
                                  index,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GridTile(
                              child: Image.network(
                                user.myPlanes[index].imageUrl,
                                fit: BoxFit.cover,
                              ),
                              footer: GridTileBar(
                                backgroundColor: Colors.black87,
                                title: Text(
                                  user.myPlanes[index].name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
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
