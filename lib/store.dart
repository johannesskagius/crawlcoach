import 'package:crawl_course_3/courses/offer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'courses/buy_offer.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}


class _StoreState extends State<Store> {
  List<GestureDetector> _offers = [];

  Future<void> _listenToOffers() async {
    Offer.courseRef.onValue.listen((event) {
      List<GestureDetector> _offerItem = [];
      for (DataSnapshot _data in event.snapshot.children) {
        _offerItem.add(_gridItem(context, Offer.fromJson(_data.value)));
      }
      setState(() {
        _offers = _offerItem;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _listenToOffers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Store',
          style: TextStyle(color: Colors.greenAccent),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(1),
        // crossAxisSpacing: 1,
        // mainAxisSpacing: 1,
        crossAxisCount: 2,
        children: _offers,
      ),
    );
  }
}

GestureDetector _gridItem(BuildContext context, Offer _offer) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BuyOffer(_offer)));
    },
    child: Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              _offer.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(children: [
                _textContainer('Sessions: '),
                _textContainer(_offer.listOfSessions.length.toString()),
              ]),
              TableRow(children: [
                _textContainer('Price: '),
                _textContainer(_offer.price),
              ]),
            ],
          ),
        ],
      ),
    ),
  );
}

Container _textContainer(String s) {
  return Container(alignment: Alignment.centerLeft, child: Text(s));
}
