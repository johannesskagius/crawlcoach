import 'package:crawl_course_3/admin/offer/buy_offer.dart';
import 'package:flutter/material.dart';

import 'admin/offer/offer.dart';

class Store extends StatelessWidget {
  const Store({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GestureDetector> _list = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
      ),
      body: FutureBuilder(
        future: Offer.getOffers(),
        builder: (BuildContext context, AsyncSnapshot<List<Offer>> snapshot) {
          if(snapshot.hasData && snapshot.data != null){
            List<Offer> _offers = snapshot.data!;
            for(Offer _offer in _offers){
             _list.add(_gridItem(context, _offer));
            }
          }else{
            const CircularProgressIndicator();
          }
        return GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 2,
          children: _list,
        );
      },
      ),

    );
  }
}

GestureDetector _gridItem(BuildContext context,Offer _offer){
  return GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => BuyOffer(_offer)));
    },
    child: Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(_offer.name,),
          Text(_offer.price),
          Text(_offer.listOfSessions.length.toString()),
        ],
      ),
    ),
  );
}

