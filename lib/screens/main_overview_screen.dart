import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/myplanes_list.dart';
import '../widgets/myoffers_list.dart';
import '../widgets/myinfo.dart';
import '../providers/user_provider.dart';

class MainOverviewScreen extends StatefulWidget {
  @override
  _MainOverviewScreenState createState() => _MainOverviewScreenState();
}

class _MainOverviewScreenState extends State<MainOverviewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
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
                text: "Airline ",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              TextSpan(
                text: "Manager",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<UserProvider>(context, listen: false).getUser(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              MyInfo(),
              SizedBox(
                height: 15,
              ),
              MyOffersList(),
              SizedBox(
                height: 15,
              ),
              MyPlanesList(),
            ],
          ),
        ),
      ),
    );
  }
}
