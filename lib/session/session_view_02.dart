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
  Map<Exercise, Object> _values = {};

  Future<void> _getListOfExercises2() async {
    DatabaseReference _ref = Exercise.exerciseRefStandard;
    String _exType = 'Gym';
    Map<Exercise, String> _gottenExercises = {};
    Map<Object?, Object?> _exercisesAmounts = widget._session.exercises;

    int i = 0;
    for (Object? _exerciseToGet in _exercisesAmounts.keys) {
      String _getInfo = _exercisesAmounts.values.elementAt(i).toString();
      _getInfo = _getInfo.substring(1, _getInfo.length - 1);
      List<String> _list = _getInfo.split(',');
      print('list: "' + _list.elementAt(1) + '"');
      if (_list.elementAt(1).trim() == 'user') {
        // true == standard
        print('user: ' + widget._id);
        _ref = Exercise.exerciseRefUser.child(widget._id);
      } else {
        _ref = Exercise.exerciseRefStandard;
      }
      switch (_list.elementAt(2).trim()) {
        case 'Body weight':
          _exType = 'Body weight';
          break;
        case 'Body Weight':
          _exType = 'Body Weight';
          break;
        case 'Swim':
          _exType = 'Swim';
          break;
        case 'Gym':
          _exType = 'Gym';
          break;
        case 't':
          _exType = 't';
          break;
      }
      // iterate through the exercise that should be collected.
      DataSnapshot _data =
          await _ref.child(_exType).child(_exerciseToGet.toString()).get();
      Exercise _ex = Exercise.fromJson(_data.value);
      String _d = _exercisesAmounts[_ex.title].toString();
      _d = _d.substring(1, _d.length);
      _gottenExercises[_ex] = _d.split(',').elementAt(0);
      i++;
    }
    setState(() {
      _values = _gottenExercises;
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
      itemCount: _values.keys.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExerciseViewPort(
                          exercise: _values.keys.elementAt(index))));
            },
            onTap: () {
              String type = _values[_values.keys.elementAt(index)]
                  .toString()
                  .substring(6);
              switch (type) {
                case 'times':
                  _openAntalProg(_values.keys.elementAt(index),
                      _values[_values.keys.elementAt(index)].toString());
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
            title: Text(_values.keys.elementAt(index).title),
            subtitle: Text(_values.keys.elementAt(index).subTitle),
            trailing: Text(_values[_values.keys.elementAt(index)].toString()),
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
