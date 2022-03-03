import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';

import 'add_session_summary.dart';

class SessionExercises extends StatefulWidget {
  const SessionExercises(this._name, this._desc, {Key? key}) : super(key: key);
  final String _name, _desc;

  @override
  _SessionExercisesState createState() => _SessionExercisesState();
}

class _SessionExercisesState extends State<SessionExercises> {
  final List<String> _chosens = [];
  int _nrChosen = 0;
  final List<Exercise> _exercises = [];

  void getOwnExercises() async {
    User2? user2 = await User2.getLocalUser();
    List<Exercise> _ex = [];
    Exercise.exerciseRefUser.child(user2!.userAuth).onValue.listen((event) {
      for (var element in event.snapshot.children) {
        Object? test = element.value;
        _ex.add(Exercise.fromJson(test));
      }
      setState(() {
        _exercises.addAll(_ex);
      });
    });
  }

  void getStandardExercises() async {
    List<Exercise> _ex = [];
    Exercise.exerciseRefStandard.onValue.listen((event) {
      for (var element in event.snapshot.children) {
        Object? test = element.value;
        print(test);
        _ex.add(Exercise.fromJson(test));
      }
      setState(() {
        _exercises.addAll(_ex);
      });
    });
  }

  void increment(int index) {
    if (!_chosens.contains(_exercises.elementAt(index).title)) {
      _chosens.add(_exercises.elementAt(index).title);
      setState(() {
        _nrChosen++;
      });
    }
  }

  @override
  void initState() {
    getOwnExercises(); //TODO set possible to filter exercises
    getStandardExercises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add exercises'),
      ),
      body: SizedBox(
        height: _height,
        width: _width,
        child: Stack(
          children: [
            SizedBox(
              height: _height,
              child: ListView.builder(
                itemCount: _exercises.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        increment(index);
                      },
                      leading: Text(index.toString()),
                      title: Text(_exercises.elementAt(index).title),
                      trailing: Text(_exercises.elementAt(index).subTitle),
                    ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SessionsSummary(Session(
                                  sessionName: widget._name,
                                  desc: widget._desc,
                                  exercises: _chosens,
                                  videoUrl: ''))));
                    },
                    child: const Text('Go to summary'),
                  ),
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
}
