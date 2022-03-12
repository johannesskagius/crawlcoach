import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'excerise/excercise.dart';

class Session02 extends StatefulWidget {
  const Session02(this._session, this._id, {Key? key, required})
      : super(key: key);

  final Session _session;
  final String _id;

  @override
  State<Session02> createState() => _Session02State();
}

class _Session02State extends State<Session02> {
  @override
  Widget build(BuildContext context) {
    Future<List<Exercise>> _getListOfExercises() async {
      List<Object?> _exToGet = widget._session.exercises.keys.toList();
      DatabaseReference _refUser = Exercise.exerciseRefUser;
      DatabaseReference _refStandard = Exercise.exerciseRefStandard;
      List<Exercise> _colEx = [];
      DataSnapshot _dataInUser;
      for (Object? exName in _exToGet) {
        _dataInUser =
            await _refUser.child(widget._id).child(exName.toString()).get();
        if (_dataInUser.value == null) {
          _dataInUser = await _refStandard.child(exName.toString()).get();
        }
        _colEx.add(Exercise.fromJson(_dataInUser.value));
      }
      return _colEx;
    }

    return FutureBuilder(
      future: _getListOfExercises(),
      builder: (BuildContext context, AsyncSnapshot<List<Exercise>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.requireData.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseViewPort(
                                exercise:
                                snapshot.requireData.elementAt(index))));
                  },
                  leading: Text(
                    index.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(snapshot.requireData.elementAt(index).title),
                  subtitle:
                  Text(snapshot.requireData.elementAt(index).subTitle),
                  //trailing: ,
                ),
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class Session021 extends StatefulWidget {
  const Session021(this._session, this._id, {Key? key}) : super(key: key);
  final Session _session;
  final String _id;

  @override
  _Session021State createState() => _Session021State();
}

class _Session021State extends State<Session021> {
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExerciseViewPort(
                              exercise: values.keys.elementAt(index))));
            },
            onLongPress: () {
              //Save result
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>));
            },
            leading: Text(
              index.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: Text(values.keys
                .elementAt(index)
                .title),
            subtitle: Text(values.keys
                .elementAt(index)
                .subTitle),
            trailing: Text(values[values.keys.elementAt(index)].toString()),
            //trailing: ,
          ),
        );
      },
    );
  }
}
