import 'package:crawl_course_3/courses/offer.dart';
import 'package:flutter/material.dart';

class BuyOffer extends StatelessWidget {
  const BuyOffer(this._offer, {Key? key}) : super(key: key);
  final Offer _offer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy: ' + _offer.name),
      ),
      body: _offer.offerPreview(true, context),
    );
  }
}
