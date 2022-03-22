import 'package:crawl_course_3/courses/offer.dart';
import 'package:flutter/material.dart';

class BuyOffer extends StatefulWidget {
  const BuyOffer(this._offer, {Key? key}) : super(key: key);
  final Offer _offer;

  @override
  State<BuyOffer> createState() => _BuyOfferState();
}

class _BuyOfferState extends State<BuyOffer> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    //_initStoreInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget._offer.offerPreview(true, context)),
    );
  }
}
