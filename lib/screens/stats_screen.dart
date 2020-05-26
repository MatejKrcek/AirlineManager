import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class StatsScreen extends StatelessWidget {
  static const routeName = '/stats-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
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
                    style: TextStyle(fontStyle: FontStyle.italic),
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
