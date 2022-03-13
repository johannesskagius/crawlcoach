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
  Map<String, String> _exReps = {};
  int _nrChosen = 0;
  Map<String, List<Exercise>> _exercisesMap = {};

  void _getOwnExercises() async {
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
    _exercisesMap.addAll(_ex);
  }

  void _getStandardExercises() async {
    Map<String, List<Exercise>> _ex = {};
    DataSnapshot snapshot = await Exercise.exerciseRefStandard.get();

    for (DataSnapshot _types in snapshot.children) {
      String _typeName = _types.key.toString();
      for (DataSnapshot _exercises in _types.children) {
        final _x = Exercise.fromJson(_exercises.value);
        //Kolla om key finns -> addera till listan
        if (_exercisesMap.containsKey(_typeName)) {
          _exercisesMap[_typeName]!.add(_x);
        } else {
          List<Exercise> _exList = [_x];
          _exercisesMap[_typeName] = _exList;
        }
      }
    }
    setState(() {});

    // Exercise.exerciseRefStandard.onValue.listen((event) {
    //   for (DataSnapshot element in event.snapshot.children) {
    //     List<Exercise> _ez = [];
    //     String s = element.key.toString();
    //     for (DataSnapshot _d in element.children) {
    //       final _x = Exercise.fromJson(_d.value);
    //       if (_exercises.containsKey(s)) {
    //         _exercises[s]!.add(_x);
    //       } else {
    //         _ez.add(_x);
    //       }
    //     }
    //     if (_ez.isNotEmpty) {
    //       _exxes[element.key.toString()] = _ez;
    //     }
    //   }
    //   setState(() {});
    // });
  }

  void _increment(Exercise _ex, String _reps) async {
    _exReps[_ex.title] = _reps;
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
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;
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
                  String _reps = await _getUnitForExercise();
                  print(_reps);
                  if (_reps != null) {
                    _increment(_exxes[_courseName]!.elementAt(index), _reps);
                  }
                },
                title: Text(_exxes[_courseName]!.elementAt(index).title),
              ),
            );
          }, childCount: _exxes[_courseName]!.length),
        ));
    }
    return _widgets;
  }

  Future<String> _getUnitForExercise() async {
    final _controller = TextEditingController();
    final _controller2 = TextEditingController();
    String _dropdownValue = 'minutes';
    String _result;
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How many repetitions?'),
        actions: [
          TextField(
            decoration: const InputDecoration(hintText: 'Reps'),
            controller: _controller,
            keyboardType: TextInputType.number,
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'times',
            ),
            controller: _controller2,
            keyboardType: TextInputType.number,
          ),
          DropdownButton(
            items: <String>[
              'meters',
              'minutes',
              'seconds',
              'kilometers',
              'times'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue!;
              });
            },
          ),
          TextButton(
              child: const Text("accept"),
              onPressed: () {
                _result = _controller.value.text +
                    ' x ' +
                    _controller.value.text +
                    ' ' +
                    _dropdownValue;
                Navigator.pop(context, _result);
              }),
        ],
      ),
    );
  }
}
