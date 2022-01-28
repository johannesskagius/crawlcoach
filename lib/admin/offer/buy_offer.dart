import 'package:crawl_course_3/account/user.dart';
import 'package:flutter/material.dart';

import 'offer.dart';

class BuyOffer extends StatelessWidget {
  const BuyOffer(this._offer, {Key? key}) : super(key: key);
  final Offer _offer;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Course name: '),
              Text(_offer.name),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Price: '),
              Text(_offer.price),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Number of sessions: '),
              Text(_offer.listOfSessions.length.toString()),
            ],
          ),
          ElevatedButton(onPressed: () async {
            LocalUser? _local = await LocalUser.getLocalUser();
            //Add sessions titles to ->
            _local!.addSessionsToAssigned(_offer.name, _offer.listOfSessions);
          }, child: Text('buy'))
        ],
      ),
    );
  }
}
