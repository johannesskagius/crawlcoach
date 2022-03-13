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
  final Map<String, String> _exercises = {};
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  String _exName = '';

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

  void _addExRes(String _ex, String _res) {
    setState(() {
      _exercises[_ex] = _res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Autocomplete(
              onSelected: (value) => {
                    _exName = value as String,
                  },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return _exNames.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              }),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Reps',
            ),
            controller: _controller1,
            keyboardType: TextInputType.number,
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Weight',
            ),
            controller: _controller2,
            keyboardType: TextInputType.number,
          ),
          TextButton(
              onPressed: () {
                String loadNReps = _controller1.value.text + ' x ';
                loadNReps += _controller2.value.text + 'kg';
                if (loadNReps.isNotEmpty && _exName.isNotEmpty) {
                  _addExRes(_exName, loadNReps);
                }
              },
              child: const Text('Add Exercise')),
          _divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _exercises.length,
            itemBuilder: (BuildContext context, int index) {
              return _exercises.isNotEmpty
                  ? Card(
                      child: ListTile(
                        title: Text(_exercises.keys.elementAt(index)),
                        subtitle: Text(_exercises.values.elementAt(index)),
                      ),
                    )
                  : const ListTile(
                      title: Text('Complete first exercise'),
                    );
            },
          )
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
