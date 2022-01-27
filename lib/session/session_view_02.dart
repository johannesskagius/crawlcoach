import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';

import 'excerise/excercise.dart';

class Session02 extends StatelessWidget {
  const Session02({Key? key, required this.session}) : super(key: key);
  final Session session;

  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = session.exercises;

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: exercises.length,
            itemBuilder: (BuildContext context, int index) {
              return ExerciseAsListTile(exercises.elementAt(index), index);
            },
          ),
        ),
      ],
    );
  }
}
