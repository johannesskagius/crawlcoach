import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/courses/offer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'edit_offer.dart';

class ViewOffers extends StatefulWidget {
  const ViewOffers({Key? key}) : super(key: key);

  @override
  State<ViewOffers> createState() => _ViewOffersState();
}

class _ViewOffersState extends State<ViewOffers> {
  List<Offer> _offers = [];

  void _getSessions() async {
    List<Offer> _exer = [];
    final user2 = User2.firebaseAuth.currentUser!.uid;
    DataSnapshot snapshot = await Offer.courseRef.get();
    for (DataSnapshot data in snapshot.children) {
      Offer _offer = Offer.fromJson(data.value);
      if (user2 == _offer.userID) {
        _exer.add(_offer);
      }
    }
    setState(() {
      _offers = _exer;
    });
  }

  @override
  void initState() {
    _getSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Offers',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
        body: ListView.builder(
          itemCount: _offers.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditCourse(_offers.elementAt(index))));
                },
                leading: Text(
                  index.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(_offers.elementAt(index).name),
                subtitle: Text(_offers.elementAt(index).desc),
              ),
            );
          },
        ));
  }
}
