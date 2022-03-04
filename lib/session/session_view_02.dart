import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'excerise/excercise.dart';

class Session02 extends StatelessWidget {
  const Session02(this._session, this._id, {Key? key, required})
      : super(key: key);

  final Session _session;
  final String _id;

  @override
  Widget build(BuildContext context) {
    Future<List<Exercise>> _getListOfExercises() async {
      List<Object?> _exToGet = _session.exercises.keys.toList();
      DatabaseReference _refUser = Exercise.exerciseRefUser;
      DatabaseReference _refStandard = Exercise.exerciseRefStandard;
      List<Exercise> _colEx = [];
      DataSnapshot _dataInUser;
      for (Object? exName in _exToGet) {
        _dataInUser = await _refUser.child(_id).child(exName.toString()).get();
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
