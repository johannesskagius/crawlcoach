import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:flutter/material.dart';

class ExerciseSummary extends StatelessWidget {
  final Exercise _exercise;
  final String _type;

  const ExerciseSummary(this._exercise, this._type, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise summary'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Divider(),
                Text(_type),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Title: ' + _exercise.title),
                    Text('Subtitle: ' + _exercise.subTitle),
                    Text('Perks: ' + _exercise.title),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(_exercise.perk1),
                    Text(_exercise.perk2),
                    Text(_exercise.perk3),
                  ],
                ),
                ElevatedButton(
                    onPressed: () async {
                      User2? user = await User2.getLocalUser();
                      if (user != null) {
                        _exercise.uploadExercise(user, _type);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('approve'))
              ],
            ),
          ),
          SizedBox(
            height: height * 0.6,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _exercise.description.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: Text(index.toString()),
                    title:
                        Text(_exercise.description.elementAt(index).toString()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
