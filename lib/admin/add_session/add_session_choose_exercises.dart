import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../session/session.dart';
import 'add_session_summary.dart';

class SessionExercises extends StatefulWidget {
  const SessionExercises(this._name, this._desc, this._sport, {Key? key})
      : super(key: key);
  final String _name, _desc, _sport;

  @override
  _SessionExercisesState createState() => _SessionExercisesState();
}

class _SessionExercisesState extends State<SessionExercises> {
  //final Map<String, List<Object>> _exReps = {};
  final Map<String, Map<String, Object>> _exReps2 = {};
  int _nrChosen = 0;
  final Map<String, List<Exercise>> _exercisesMap = {};
  final Set<String> _standard = {};

  void _getOwnExercises() async {
    User2? user = await User2.getLocalUser();

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

  void _increment(Exercise _ex, List<String> _reps, String _exCat) async {
    String _isUserMade = 'user';
    if (_standard.contains(_ex.title)) {
      _isUserMade = 'standard';
    }
    _exReps2.putIfAbsent(
      _ex.title,
      () => {
        'set': _reps.elementAt(0),
        'reps': _reps.elementAt(1),
        'userMade': _isUserMade,
        'exCat': _exCat,
        'exType': _reps.elementAt(2)
      },
    );
    setState(() {
      _nrChosen++;
    });
  }

  @override
  void initState() {
    //_getOwnExercises(); //TODO set possible to filter exercises
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
                                  '',
                                      widget._sport,
                                      exercises: _exReps2,
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
                  List<String> _setAndReps =
                      await Exercise.setUnitAndReps(context);
                  _increment(_exxes[_courseName]!.elementAt(index), _setAndReps,
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
