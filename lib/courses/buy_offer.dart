import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/courses/offer.dart';
import 'package:flutter/material.dart';

class BuyOffer extends StatelessWidget {
  const BuyOffer(this._offer, {Key? key}) : super(key: key);
  final Offer _offer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Course name: '),
              Text(_offer.name),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Price: '),
              Text(_offer.price),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Number of sessions: '),
              Text(_offer.listOfSessions.length.toString()),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                User2? _local = await User2.getLocalUser();
                //Add sessions to the userprofile
                _local!.assignToCourse(_offer);
                Navigator.pop(context);
              },
              child: const Text('buy'))
        ],
      ),
    );
  }
}
