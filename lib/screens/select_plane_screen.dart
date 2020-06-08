import 'package:flutter/material.dart';

import '../models/myAirplanes.dart';
import '../models/offer.dart';

class ChooseAirplane extends StatefulWidget {
  final List<MyAirplane> myAirplanes;
  final List<Offer> offers;
  final int index;

  ChooseAirplane(
    this.myAirplanes,
    this.offers,
    this.index,
  );

  @override
  ChooseAirplaneState createState() => ChooseAirplaneState();
}

class ChooseAirplaneState extends State<ChooseAirplane> {
  TextEditingController editingController = TextEditingController();
  static List<String> listOfNames = [];
  var duplicateItems = listOfNames;
  var items = List<String>();

  void savePlane(int index, List items) {
    print(items[index]);
    
    Navigator.pop(context, index);
  }

  @override
  void initState() {
    List<String> listOfNames = [];
    duplicateItems = listOfNames;
    items = List<String>();
    for (var i = 0; i < widget.myAirplanes.length; i++) {
      duplicateItems.add(widget.myAirplanes[i].name);
    }
    items.addAll(duplicateItems);
    print(items);
    items.sort((a, b) => a.compareTo(b));
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Select ",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              TextSpan(
                text: "Airplane",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      savePlane(index, items);
                    },
                    child: Card(
                      elevation: 3,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('${items[index]}'),
                            trailing: Container(
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  widget.myAirplanes[index].imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  left: 15,
                                  bottom: 5,
                                ),
                                child: Text(
                                  'Seats: ${widget.myAirplanes[index].seats}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  left: 15,
                                  bottom: 5,
                                ),
                                child: Text(
                                  'Speed: ${widget.myAirplanes[index].speed}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  right: 35,
                                  left: 15,
                                  bottom: 5,
                                ),
                                child: Text(
                                  'Available',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  left: 15,
                                  bottom: 5,
                                ),
                                child: Text(
                                  'Flight range: ${widget.myAirplanes[index].distance}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
