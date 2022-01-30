import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'admin/offer/buy_offer.dart';
import 'admin/offer/offer.dart';

class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  List<Offer> _listOfOffers= [];

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
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Container(
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
          },),
      ),
    );
  }
}
