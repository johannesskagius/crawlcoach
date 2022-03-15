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
