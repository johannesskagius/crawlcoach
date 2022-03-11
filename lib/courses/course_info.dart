import 'package:crawl_course_3/courses/offer.dart';
import 'package:flutter/material.dart';

import '../contact_course_admin.dart';

class CourseInfo extends StatelessWidget {
  const CourseInfo({Key? key, required this.courseName}) : super(key: key);
  final Offer courseName;

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
        body: SafeArea(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            courseName.offerCard(_height),
            courseName.previewTable(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactAdmin()));
                },
                child: const Text('Contact course creator'))
          ],
        ),
      ),
    ));
  }
}


