import 'package:crawl_course_3/courses/offer.dart';
import 'package:flutter/material.dart';

class CourseInfo extends StatelessWidget {
  const CourseInfo({Key? key, required this.courseName}) : super(key: key);
  final Offer courseName;

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Course info',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              courseName.offerCard(_height),
              courseName.previewTable(),
            ],
          ),
        ));
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
