import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../session/session.dart';
import 'add_session_summary.dart';

class SessionExercises extends StatefulWidget {
  const SessionExercises(this._name, this._desc, {Key? key}) : super(key: key);
  final String _name, _desc;

  @override
  _SessionExercisesState createState() => _SessionExercisesState();
}

class _SessionExercisesState extends State<SessionExercises> {
  final Map<String, List<Object>> _exReps = {};
  int _nrChosen = 0;
  final Map<String, List<Exercise>> _exercisesMap = {};
  final Set<String> _standard = {};

  void _getOwnExercises() async {
    User2? user = await User2.getLocalUser();
    Map<String, List<Exercise>> _ex = {};

    DataSnapshot snapshot =
        await Exercise.exerciseRefUser.child(user!.userAuth).get();
    for (DataSnapshot _types in snapshot.children) {
      List<Exercise> _exer = [];
      String typeName = _types.key.toString();
      for (DataSnapshot _exercises in _types.children) {
        final _ex = Exercise.fromJson(_exercises.value);
        _exer.add(_ex);
      }
      setState(() {
        _exercisesMap[typeName] = _exer;
      });
    }
  }

  void _getStandardExercises() async {
    DataSnapshot snapshot = await Exercise.exerciseRefStandard.get();
    for (DataSnapshot _types in snapshot.children) {
      String _typeName = _types.key.toString();
      for (DataSnapshot _exercises in _types.children) {
        final _x = Exercise.fromJson(_exercises.value);
        _standard.add(_x.title);
        if (_exercisesMap.containsKey(_typeName)) {
          _exercisesMap[_typeName]!.add(_x);
        } else {
          List<Exercise> _exList = [_x];
          _exercisesMap[_typeName] = _exList;
        }
      }
    }
    setState(() {});
  }

  void _increment(Exercise _ex, String _reps, String _exType) async {
    String _isUserMade = 'user';
    if (_standard.contains(_ex.title)) {
      _isUserMade = 'standard';
    }
    if (_exReps.containsKey(_ex.title)) {
      _exReps[_ex.title]!
        ..add(_reps)
        ..add(_isUserMade.toString())
        ..add(_exType);
    } else {
      List<Object> _list = [_reps, _isUserMade, _exType];
      _exReps[_ex.title] = _list;
    }
    setState(() {
      _nrChosen++;
    });
  }

  @override
  void initState() {
    _getOwnExercises(); //TODO set possible to filter exercises
    _getStandardExercises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: Stack(
          children: [
            CustomScrollView(
              shrinkWrap: true,
              slivers: _sliverList(context, _exercisesMap),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SessionsSummary(Session(
                                      exercises: _exReps,
                                      sessionName: widget._name,
                                      desc: widget._desc,
                                      videoUrl: '',
                                    ))));
                      },
                      child: const Text('Move next')),
                  FloatingActionButton(
                      onPressed: () {
                        //TODO implement functions
                      },
                      child: Text(_nrChosen.toString())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _sliverList(
      BuildContext context, Map<String, List<Exercise>> _exxes) {
    List<Widget> _widgets = [];
    _widgets.add(const SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        title:
            Text('Add exercises', style: TextStyle(color: Colors.greenAccent)),
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
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Card(
              child: ListTile(
                onTap: () async {
                  String _reps = await Exercise.setUnitAndReps(context);
                  _increment(_exxes[_courseName]!.elementAt(index), _reps,
                      _courseName);
                },
                title: Text(_exxes[_courseName]!.elementAt(index).title),
              ),
            );
          }, childCount: _exxes[_courseName]!.length),
        ));
    }
    return _widgets;
  }
}
