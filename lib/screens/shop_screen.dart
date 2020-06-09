import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/app_drawer.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = '/shop-screen';

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _buy(int index) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final data = Provider.of<UserProvider>(context, listen: false);
    if (user[0].coins >= data.listOfAirplanes[index].price) {
      user[0].coins = user[0].coins - data.listOfAirplanes[index].price;
      // removeCoins(listOfAirplanes[index].price);

      // myAirplanes.add(listOfAirplanes[index]);
      // print(myAirplanes.length);

      await data.buyAirplane(index);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Congrats! Check your inventory'),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } else {
      print('Not enought coins');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Not enought coins!'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  void _showDialog(int index) {
    final data = Provider.of<UserProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text("Are you sure?"),
          content: RichText(
            text: TextSpan(
              text: 'Do you want to buy ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: data.listOfAirplanes[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' for ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: data.listOfAirplanes[index].price.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' coins?',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Buy now",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                _buy(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProvider>(context, listen: false).getAllAirlanes(),
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
                key: _scaffoldKey,
                backgroundColor: Colors.white,
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
                          text: "Airplane ",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        TextSpan(
                          text: "Shop",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ],
                    ),
                  ),
                ),
                drawer: AppDrawer(),
                body: RefreshIndicator(
                  onRefresh: () =>
                      Provider.of<UserProvider>(context, listen: false)
                          .getAllAirlanes(),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title:
                                Text('Coins: ${user.user[0].coins.toString()}'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
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
                                            text: "Airplanes ",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold,
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
                                height: 280,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: user.listOfAirplanes.length,
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.grey,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                user.listOfAirplanes[index]
                                                    .imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            user.listOfAirplanes[index].name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Theme.of(context).accentColor,
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
                                                  'Range: ${user.listOfAirplanes[index].distance.toString()} km',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  'Seats: ${user.listOfAirplanes[index].seats.toString()}',
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  'Speed: ${user.listOfAirplanes[index].speed.toString()}',
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
                                                margin: EdgeInsets.only(
                                                  left: 15,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  '${user.listOfAirplanes[index].price.toString()} coins',
                                                  textAlign: TextAlign.center,
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
                                                child: FlatButton(
                                                  onPressed: user
                                                              .user[0].coins <
                                                          user
                                                              .listOfAirplanes[
                                                                  index]
                                                              .price
                                                      ? null
                                                      : () {
                                                          _showDialog(index);
                                                        },
                                                  child: Text(
                                                    'BUY NOW',
                                                    style: TextStyle(
                                                      color: user.user[0]
                                                                  .coins <
                                                              user
                                                                  .listOfAirplanes[
                                                                      index]
                                                                  .price
                                                          ? Colors.grey
                                                          : Theme.of(context)
                                                              .primaryColor,
                                                    ),
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
                      ],
                    ),
                  ),
                )),
          );
        }
      },
    );
  }
}
