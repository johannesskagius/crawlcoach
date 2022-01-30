import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:flutter/material.dart';

class ExerciseViewPort extends StatelessWidget {
  const ExerciseViewPort({Key? key, required this.exercise}) : super(key: key);
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    double _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text(exercise.title),
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              // SizedBox(
              //   width: _width,
              //   height: _height * 0.4,
              //   child: Container(
              //     color: Colors.black54,
              //     alignment: Alignment.center,
              //     child: Text('Video'),
              //   ),
              // ), //TODO show video of excercise,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(exercise.perk1),
                  Text(exercise.perk2),
                  Text(exercise.perk3)
                ],
              ),
              Expanded(child: ListView.builder(itemCount: exercise.description.length, itemBuilder: (BuildContext context, int index) {
                return Explained(number: index.toString(), description: exercise.description.elementAt(index), width: _width,);
              },))
            ],
          ),
        ));
  }
}

