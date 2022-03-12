import 'dart:async';

import 'package:crawl_course_3/courses/offer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'account/user2.dart';
import 'courses/buy_offer.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  List<Offer> _offers = [];

  void initiate() async {
    if (User2.firebaseAuth.currentUser!.isAnonymous) {
      _listenToOffers(null);
    } else {
      final user = await User2.getLocalUser();
      _listenToOffers(User2.ref.child(user!.userAuth).child('a_sessions'));
    }
  }

  Future<void> _listenToOffers(DatabaseReference? _ref) async {
    List<Offer> _alreadyAssigned = [];
    if (_ref != null) {
      final dataSnap = await _ref.get();
      for (DataSnapshot _data in dataSnap.children) {
        _alreadyAssigned.add(Offer.fromJson(_data.value));
      }
    }

    Offer.courseRef.onValue.listen((event) {
      List<Offer> _offerItem = [];
      for (DataSnapshot _data in event.snapshot.children) {
        Offer _offer = Offer.fromJson(_data.value);
        if (!_alreadyAssigned.contains(_offer)) {
          _offerItem.add(_offer);
        }
      }
      setState(() {
        _offers = _offerItem;
      });
    });
  }

  @override
  void initState() {
    initiate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: _offers.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BuyOffer(_offers.elementAt(index))));
              },
              child: _offers.elementAt(index).offerCard(_height),
            );
          },
        ),
      ),
    );
  }
}
