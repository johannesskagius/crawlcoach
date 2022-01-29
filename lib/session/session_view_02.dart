import 'dart:convert';

import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'excerise/excercise.dart';

class Session02 extends StatelessWidget {
  const Session02({Key? key, required this.session}) : super(key: key);
  final Session session;

  @override
  Widget build(BuildContext context) {
    //List<String> exercisesIDS = session.exercises; //TODO Excercises should be collected from server and displayed.

    Future<List<Exercise>> _getListOfExercises() async {
      List<Exercise> _listWithWantedExercises = [];
      DatabaseReference _ref = FirebaseDatabase.instance.ref();
      //Get keys from session
      List<dynamic> exerciseKeyList = session.exercises;

      for (dynamic exerciseKey in exerciseKeyList) {
        DataSnapshot exerciseSnap =
            await _ref.child('exercises').child(exerciseKey).get();
        Exercise _exercise = Exercise.fromJson(exerciseSnap.value);
        _listWithWantedExercises.add(_exercise);
      }
      return _listWithWantedExercises;
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
