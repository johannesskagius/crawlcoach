import 'package:flutter/material.dart';

import 'admin/courses/buy_offer.dart';
import 'admin/courses/offer.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}


class _StoreState extends State<Store> {
  Future<List<GestureDetector>> _getOffers() async {
    List<GestureDetector> _offerItem = [];
    List<Offer> offersList = await Offer.getOffers();
    for (Offer offer in offersList) {
      _offerItem.add(_gridItem(context, offer));
    }
    return _offerItem;
  }

  @override
  void initState() {
    super.initState();
    _getOffers();
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
      body: FutureBuilder(
        future: _getOffers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              padding: const EdgeInsets.all(1),
              // crossAxisSpacing: 1,
              // mainAxisSpacing: 1,
              crossAxisCount: 2,
              children: snapshot.data,
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
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
