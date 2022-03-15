import 'dart:convert';

import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'own_sess_add_ex.dart';

class FreeSession extends StatefulWidget {
  const FreeSession({Key? key}) : super(key: key);

  @override
  _FreeSessionState createState() => _FreeSessionState();
}

class _FreeSessionState extends State<FreeSession> {
  final _controller = PageController();
  final List<String> _exNames = [];

  void _getAllExercises() async {
    DataSnapshot _data = await Exercise.exerciseRefStandard.child('Gym').get();
    for (DataSnapshot _exName in _data.children) {
      _exNames.add(_exName.key.toString());
    }
  }

  @override
  void initState() {
    _getAllExercises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: _controller,
          pageSnapping: true,
          onPageChanged: (value) => {
            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus(),
          },
          children: [
            AddExercises(_exNames),
            const OverView(),
          ],
        ),
        bottomNavigationBar: Row(),
      ),
    );
  }
}

class OverView extends StatefulWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  _OverViewState createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  Map<String, dynamic> _exer = {};
  Map<String, List<String>> _exerPresent = {};
  Duration? _sessDur;

  void _loadNCountEx() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String? s = _shared.getString('EX');
    _exer = json.decode(s!);
    for (String _x in _exer.keys) {
      String _exName = _x.substring(1);
      if (_exerPresent.containsKey(_exName)) {
        String _resr = _exer[_x].toString();
        _exerPresent[_exName]!.add(_resr);
      } else {
        List<String> _list = [_exName];
        _exerPresent[_exName] = _list;
      }
    }
    setState(() {});
  }

  void _getWorkOutTime() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    DateTime _date = DateTime.parse(_shared.getString('date')!);
    setState(() {
      _sessDur = DateTime.now().difference(_date);
    });
  }

  @override
  void initState() {
    _loadNCountEx();
    _getWorkOutTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Great job!'),
        _sessDur != null ? Text(_sessDur!.inMinutes.toString()) : Container(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _exerPresent.keys.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(_exerPresent.keys.elementAt(index)),
                trailing: Text(
                    _exerPresent.values.elementAt(index).length.toString()),
              ),
            );
          },
        ),
        ElevatedButton(
            onPressed: () async {
              SharedPreferences _shared = await SharedPreferences.getInstance();
              //remove all
              _shared.remove('EX');
              _shared.remove('date');
              Navigator.pop(context);
            },
            child: const Text('Completed'))
      ],
    );
  }
}
