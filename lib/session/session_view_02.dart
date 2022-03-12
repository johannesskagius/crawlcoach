import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'excerise/excercise.dart';
import 'excerise/exercise_result.dart';

class Session02 extends StatefulWidget {
  const Session02(this._session, this._id, {Key? key}) : super(key: key);
  final Session _session;
  final String _id;

  @override
  _Session02State createState() => _Session02State();
}

class _Session02State extends State<Session02> {
  Map<Exercise, Object> values = {};

  Future<void> _getListOfExercises2() async {
    Map<Exercise, String> _gottenExercises = {};
    Map<Object?, Object?> _exercisesAmounts = widget._session.exercises;

    for (Object? _exerciseToGet in _exercisesAmounts.keys) {
      // iterate through the exercise that should be collected.
      //Check if standard made,
      DataSnapshot _data = await Exercise.exerciseRefStandard
          .child(_exerciseToGet.toString())
          .get();
      if (!_data.exists) {
        //Check if userMade
        _data = await Exercise.exerciseRefUser
            .child(widget._id)
            .child(_exerciseToGet.toString())
            .get();
      }
      Exercise _ex = Exercise.fromJson(_data.value);
      _gottenExercises[_ex] = _exercisesAmounts[_ex.title].toString();
    }
    setState(() {
      values = _gottenExercises;
    });
  }

  @override
  void initState() {
    _getListOfExercises2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: values.keys.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExerciseViewPort(
                          exercise: values.keys.elementAt(index))));
            },
            onTap: () {
              String type =
                  values[values.keys.elementAt(index)].toString().substring(6);
              switch (type) {
                case 'times':
                  _openAntalProg(values.keys.elementAt(index),
                      values[values.keys.elementAt(index)].toString());
                  break;
                case 'minutes':
                  break;
                case 'seconds':
                  break;
                case 'kilometers':
                  break;
                case 'meters':
                  break;
              }
            },
            leading: Text(
              index.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: Text(values.keys.elementAt(index).title),
            subtitle: Text(values.keys.elementAt(index).subTitle),
            trailing: Text(values[values.keys.elementAt(index)].toString()),
            //trailing: ,
          ),
        );
      },
    );
  }

  void _openAntalProg(Exercise _exercise, String _repsSet) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExerciseResult(_exercise, _repsSet)));
  }
}
