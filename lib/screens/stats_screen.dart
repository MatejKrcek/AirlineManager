import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/app_drawer.dart';

class StatsScreen extends StatelessWidget {
  static const routeName = '/stats-screen';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                text: "Statistics",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              TextSpan(
                text: " and Scoreboard",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Username',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Coins',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Total flight distance',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: const <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Matej')),
                    DataCell(Text('8300')),
                    DataCell(Text('3200 km')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Tester')),
                    DataCell(Text('200')),
                    DataCell(Text('250 km')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Martin')),
                    DataCell(Text('1400')),
                    DataCell(Text('530 km')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
