import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/courses/offer.dart';
import 'package:flutter/material.dart';

class BuyOffer extends StatelessWidget {
  const BuyOffer(this._offer, {Key? key}) : super(key: key);
  final Offer _offer;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: _height / 3,
              child: Image.file(
                _offer.getImage(),
                fit: BoxFit.fitHeight,
              )),
          _offer.previewTable(_width, _height),
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
