import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'excercise.dart';

class ViewExercises extends StatefulWidget {
  const ViewExercises({Key? key}) : super(key: key);

  @override
  State<ViewExercises> createState() => _ViewExercisesState();
}

class _ViewExercisesState extends State<ViewExercises> {
  final asset = 'assets/videos/IMG_4498_HD.mp4';
  VideoPlayerController? controller;
  List<Exercise> _exercises = [];

  void _getExercises() async {
    User2? user = await User2.getLocalUser();
    List<Exercise> _exer = [];
    DataSnapshot snapshot =
        await Exercise.exerciseRefUser.child(user!.userAuth).get();
    for (DataSnapshot data in snapshot.children) {
      print(data.key.toString());
      _exer.add(Exercise.fromJson(data.value));
    }
    setState(() {
      _exercises = _exer;
    });
  }

  @override
  void initState() {
    _getExercises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Exercises'),
        ),
        body: ListView.builder(
          itemCount: _exercises.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExerciseViewPort(
                              exercise: _exercises.elementAt(index))));
                },
                leading: Text(
                  index.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(_exercises.elementAt(index).title),
                subtitle: Text(_exercises.elementAt(index).subTitle),
              ),
            );
          },
        ));
  }
}
