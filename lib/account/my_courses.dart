import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../admin/offer/buy_offer.dart';
import '../admin/offer/offer.dart';

//todo change to my courses use silvergrid / Silver list!
class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
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
        String? objOffer = element.value.toString();
        //_ex.add(Offer.fromJson(jsonDecode(objOffer)));
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
    return SliverAppBar(
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
