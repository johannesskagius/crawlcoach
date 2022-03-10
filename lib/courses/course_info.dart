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


