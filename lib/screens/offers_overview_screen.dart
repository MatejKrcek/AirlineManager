import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/offers.dart';
import '../providers/offers_provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class OffersOverviewScreen extends StatefulWidget {
  static const routeName = '/offers-screen';
  @override
  _OffersOverviewScreenState createState() => _OffersOverviewScreenState();
}

class _OffersOverviewScreenState extends State<OffersOverviewScreen> {
  var _showOnFlight = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
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
                text: "Flight ",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              TextSpan(
                text: "Offers",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            tooltip: 'Show Filters',
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnFlight = true;
                } else {
                  _showOnFlight = false;
                }
              });
            },
            icon: Icon(
              Icons.filter_list,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only On Flight'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All Available'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<OffersProvider>(context, listen: false).getFlights(),
        child: Offers(_showOnFlight),
      ),
    );
  }
}
