import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'own_sess_add_ex.dart';
import 'own_sess_sum.dart';

class FreeSession extends StatefulWidget {
  const FreeSession({Key? key}) : super(key: key);

  @override
  _FreeSessionState createState() => _FreeSessionState();
}

class _FreeSessionState extends State<FreeSession> {
  final _controller = PageController();
  final Map<String, String> _exNames = {}; //Exercise type, Exercise Name

  void _getAllExercises() async {
    DataSnapshot _data = await Exercise.exerciseRefStandard.get();
    for (DataSnapshot _exType in _data.children) {
      for (DataSnapshot _exName in _exType.children) {
        _exNames[_exType.key.toString()] = (_exName.key.toString());
      }
    }
  }

  @override
  void initState() {
    _getAllExercises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _actionBar = [];

    void _pageChanged(int value) {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    }

    return GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Session'),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.filter_1_outlined)),
          ],
        ),
        body: PageView(
          controller: _controller,
          pageSnapping: true,
          onPageChanged: _pageChanged,
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
