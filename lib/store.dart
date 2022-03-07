import 'dart:async';

import 'package:crawl_course_3/courses/offer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'account/user2.dart';
import 'courses/buy_offer.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}


class _StoreState extends State<Store> {
  List<Offer> _offers = [];
  late StreamSubscription listen;

  Future<void> _listenToOffers() async {
    final user = await User2.getLocalUser();
    List<Offer> _alreadyAssigned = [];
    final dataSnap =
        await User2.ref.child(user!.userAuth).child('a_sessions').get();
    for (DataSnapshot _data in dataSnap.children) {
      _alreadyAssigned.add(Offer.fromJson(_data.value));
    }

    listen = Offer.courseRef.onValue.listen((event) {
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
    super.initState();
    _listenToOffers();
  }

  @override
  void dispose() {
    super.dispose();
    listen.cancel();
  }

  @override
  void deactivate() {
    super.deactivate();
    listen.pause();
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
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Text(
                        _offers.elementAt(index).name,
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(_offers.elementAt(index).name),
                    ),
                    Image.asset(
                      'assets/crawl.jpeg',
                      fit: BoxFit.contain,
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(_offers.elementAt(index).price),
                      trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
