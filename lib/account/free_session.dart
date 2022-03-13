import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FreeSession extends StatelessWidget {
  const FreeSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free session'),
      ),
      body: const DoExercise(),
    );
  }
}

class DoExercise extends StatefulWidget {
  const DoExercise({Key? key}) : super(key: key);

  @override
  _DoExerciseState createState() => _DoExerciseState();
}

class _DoExerciseState extends State<DoExercise> {
  final List<String> _exNames = [];
  final List<String> _exercises = [];

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
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Autocomplete(optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _exNames.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          }),
          TextButton(onPressed: () {}, child: const Text('Add Exercise'))
        ],
      ),
    );
  }
}

Divider _divider() {
  return const Divider(
    height: 5,
  );
}
