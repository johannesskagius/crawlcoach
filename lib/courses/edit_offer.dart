import 'package:crawl_course_3/courses/offer_chose_sessions.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';

import 'offer.dart';

class EditCourse extends StatelessWidget {
  const EditCourse(this._offer, {Key? key}) : super(key: key);
  final Offer _offer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_offer.name),
      ),
      body: offerInfo(_offer, context),
    );
  }
}

Container offerInfo(Offer _offer, BuildContext context) {
  double _width = MediaQuery.of(context).size.width;
  double _height =
      MediaQuery.of(context).size.height - AppBar().preferredSize.height;
  return Container(
    margin: const EdgeInsets.all(8),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
              onTap: () {
                //Update picture,
              },
              child: Image.asset('assets/crawl.jpeg')),
          _offer.previewTable(),
          GestureDetector(
            onLongPress: () {
              //Change sessions
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChooseSessions(
                          _offer.name, _offer.price, _offer.desc, null)));
            },
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _offer.listOfSessions.length,
              itemBuilder: (BuildContext context, int index) {
                return SessionPreviewNoSession(
                    _offer.listOfSessions.keys.elementAt(index).toString(),
                    _offer.userID,
                    _offer.name);
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Offer.courseRef.child(_offer.name).remove();
                Navigator.pop(context);
              },
              child: const Text('Remove course'))
        ],
      ),
    ),
  );
}
