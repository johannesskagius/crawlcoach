import 'dart:convert';

import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'excerise/excercise.dart';

class Session02 extends StatefulWidget {
  const Session02(this._session, this._id, {Key? key}) : super(key: key);
  final Session _session;
  final String _id;

  @override
  _Session02State createState() => _Session02State();
}

class _Session02State extends State<Session02> {
  Map<Exercise, Map<String, dynamic>> _values = {};

  Future<void> _getListOfExercises() async {
    switch (widget._session.sessionType) {
      case 'Gym':
        await _exercisesOnGymApi();
        break;
      case 'Swim':
      case 'Run':
      case 'Yoga':
      case 'Bike':
        await _exercisesOnFirebase();
        break;
    }
  }

  Future<void> _exercisesOnFirebase() async {
    DatabaseReference _ref = Exercise.exerciseRef;
    Map<Exercise, Map<String, dynamic>> _gottenExercises = {};
    for (Object? _exerciseToGet in widget._session.exercises.keys) {
      String s = jsonEncode(widget._session.exercises[_exerciseToGet]);
      Map<String, dynamic> _t = jsonDecode(s);
      DataSnapshot _x = await _ref
          .child(_t['userMade'])
          .child(_t['exCat'])
          .child(_exerciseToGet.toString())
          .get();
      final _ex = Exercise.fromJson(_x.value);
      _ex.other!['r_Type'] = _t['exType'];
      _gottenExercises[_ex] = _t;
    }
    setState(() {
      _values = _gottenExercises;
    });
  }

  @override
  void initState() {
    _getListOfExercises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _values.keys.length,
      itemBuilder: (BuildContext context, int index) {
        final _ex = _values.keys.elementAt(index);
        String _setNReps = _values[_values.keys.elementAt(index)]!['set'] +
            ' x ' +
            _values[_values.keys.elementAt(index)]!['reps'] +
            ' ' +
            _values[_values.keys.elementAt(index)]!['exType'];
        return Card(
          child: ListTile(
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExerciseViewPort(
                          exercise: _values.keys.elementAt(index))));
            },
            onTap: () async {
              _values.keys
                  .elementAt(index)
                  .addExerciseResult(context, _setNReps);
            },
            leading: Text(
              index.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: Text(_ex.title),
            subtitle: Text(_ex.subTitle),
            trailing: Text(_setNReps),
            //trailing: ,
          ),
        );
      },
    );
  }

  _exercisesOnGymApi() {}
}
