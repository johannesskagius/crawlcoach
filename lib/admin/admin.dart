import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  _downloadAllEx();
                },
                child: const Text('Format')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addoffer');
                    },
                    child: const Text('Add Offer')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/viewOffers');
                    },
                    child: const Text('View my offers')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addsession');
                    },
                    child: const Text('Add Session')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/viewSessions');
                    },
                    child: const Text('View my sessions')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addexercise');
                    },
                    child: const Text('Add exercise')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/viewexercises');
                    },
                    child: const Text('View my exercises')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _downloadAllEx() async {
    List<DataSnapshot> _list = [
      await Exercise.exerciseRefStandard.child('Gym').get(),
      await Exercise.exerciseRefStandard.child('Body weight').get(),
      await Exercise.exerciseRefStandard.child('Swim').get()
    ];
    Map<Object?, Object?> other = {};
    Map<Object?, Object?> _extype = {};

    /*
                                      'r_Type': _s,
                                  'standard': 'standard',
                                  'w_type': _txtEditList.elementAt(7).value.text
    * */
    for (DataSnapshot _ExerciseTYPE in _list) {
      //
      for (DataSnapshot _exercise in _ExerciseTYPE.children) {
        other['r_Type'] = 'times';
        other['standard'] = 'standard';
        other['w_Type'] = _ExerciseTYPE.key.toString();
        other['equipment'] = 'H';
        final _ex = Exercise.fromJson(_exercise.value);
        _ex.other = other;
        Exercise.exerciseRefStandard
            .child(_ExerciseTYPE.key.toString().trim())
            .child(_ex.title)
            .set(_ex.toJson());
      }
    }
  }
}
