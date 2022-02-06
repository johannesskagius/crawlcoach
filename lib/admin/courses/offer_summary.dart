import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'offer.dart';

class OfferSummary extends StatelessWidget {
  OfferSummary(this._offer, {Key? key}) : super(key: key);
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final Offer _offer;

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('summary'),
      ),
      body: SizedBox(
        width: _width,
        height: _height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Name: '),
                Text(_offer.name),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Desc: '),
                Text(_offer.price),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Nr och exercises: '),
                Text(_offer.listOfSessions.length.toString()),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () {
          _ref.child('courses').child(_offer.name).set(_offer.toJson());
          Navigator.pop(context);
        },
        child: const Text('To Server'),
      ),
    );
  }
}
