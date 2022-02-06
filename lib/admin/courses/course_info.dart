import 'package:crawl_course_3/admin/courses/offer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CourseInfo extends StatelessWidget {
  const CourseInfo({Key? key, required this.courseName}) : super(key: key);
  final String courseName;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    Future<Offer?> _getOffer() async {
      Offer? _offer;
      DataSnapshot _offerData = await Offer.courseRef.child(courseName).get();
      _offer = Offer.fromJson(_offerData.value);
      return _offer;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course info',
          style: TextStyle(color: Colors.greenAccent),
        ),
      ),
      body: FutureBuilder(
        future: _getOffer(),
        builder: (BuildContext context, AsyncSnapshot<Offer?> snapshot) {
          List<Widget> _widget = [];
          if (snapshot.hasData) {
            _widget.add(_getOfferInfo(_width, snapshot.data));
          } else {
            _widget.add(const CircularProgressIndicator());
          }
          return Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(courseName),
                ),
                Column(
                  children: _widget,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Container _textContainer(String s, Alignment _align) {
  return Container(alignment: Alignment.centerLeft, child: Text(s));
}

Container _getOfferInfo(double _width, Offer? _offer) {
  return Container(
    margin: const EdgeInsets.all(8),
    child: Table(
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(_width * 0.3),
        1: const FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(children: [
          _textContainer('Title: ', Alignment.centerLeft),
          _textContainer(_offer!.name, Alignment.center),
        ]),
        TableRow(children: [
          _textContainer('Description: ', Alignment.centerLeft),
          _textContainer(_offer.desc, Alignment.center),
        ]),
        TableRow(children: [
          _textContainer('Sessions: ', Alignment.centerLeft),
          _textContainer(
              _offer.listOfSessions.length.toString(), Alignment.center),
        ]),
      ],
    ),
  );
}
