import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewExercises extends StatefulWidget {
  const ViewExercises({Key? key}) : super(key: key);

  @override
  State<ViewExercises> createState() => _ViewExercisesState();
}

class _ViewExercisesState extends State<ViewExercises> {
  final asset = 'assets/videos/IMG_4498_HD.mp4';
  VideoPlayerController? controller;
  Map<String, List<Exercise>> _exercises = {};

  void _getExercises() async {
    User2? user = await User2.getLocalUser();
    Map<String, List<Exercise>> _ex = {};

    DataSnapshot snapshot =
        await Exercise.exerciseRefUser.child(user!.userAuth).get();
    for (DataSnapshot _types in snapshot.children) {
      List<Exercise> _exer = [];
      String typeName = _types.key.toString();
      for (DataSnapshot _exercises in _types.children) {
        _exer.add(Exercise.fromJson(_exercises.value));
      }
      _ex[typeName] = _exer;
    }
    setState(() {
      _exercises = _ex;
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
      body: Scrollbar(
        child: CustomScrollView(
          slivers: _sliverList(context, _exercises),
        ),
      ),
    );
  }
}

List<Widget> _sliverList(
    BuildContext context, Map<String, List<Exercise>> _exxes) {
  List<Widget> _widgets = [];
  _widgets.add(const SliverAppBar(
    flexibleSpace: FlexibleSpaceBar(
      title: Text('Add exercises', style: TextStyle(color: Colors.greenAccent)),
    ),
    actions: [],
  ));
  for (int _i = 0; _i < _exxes.keys.length; _i++) {
    String _courseName = _exxes.keys.elementAt(_i);
    _widgets
      ..add(SliverAppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            _courseName,
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ),
        expandedHeight: 50,
        floating: true,
      ))
      ..add(SliverFixedExtentList(
        itemExtent: 60.0,
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(_exxes[_courseName]!.elementAt(index).title),
            ),
          );
        }, childCount: _exxes[_courseName]!.length),
      ));
  }
  return _widgets;
}

/*
*       body: ListView.builder(
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
        )
* */