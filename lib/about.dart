import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'admin/offer/buy_offer.dart';
import 'admin/offer/offer.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  List<Offer> _listOfOffers= [];
  List<bool> _listSelected = [];

  @override
  void initState() {
    _activateListener();
    super.initState();
  }

  void _activateListener(){
    List<Offer> _ex = [];
    _ref.child('courses').onValue.listen((event) {
      for(var element in event.snapshot.children){
        Object? objOffer = element.value;
        _ex.add(Offer.fromJson(objOffer));
      }
      setState(() {
        _listOfOffers = _ex;
      });
    });
  }

  void markPressed(){
    _listSelected = List.generate(_listOfOffers.length, (index) => false);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        title: const Text('about'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: _listOfOffers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  selectedTileColor: Colors.red,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BuyOffer(_listOfOffers.elementAt(index))));
                  },
                  title: Text(_listOfOffers.elementAt(index).name),
                  trailing: Text(_listOfOffers.elementAt(index).price),
                ),
              );
            },)),
    );
  }
}
