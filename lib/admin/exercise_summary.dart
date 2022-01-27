

import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ExerciseSummary extends StatelessWidget {
  ExerciseSummary(this._exercise, {Key? key}) : super(key: key);
  final Exercise _exercise;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise summary'),
      ),
      body: SizedBox(
        width: _width,
        height: _height,
        child: Column(
          children: [
            SizedBox(
              height: _height*.1,
              width: _width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Title: ' + _exercise.title),
                      Text('Subtitle: '+ _exercise.subTitle!),
                      Text('Perks: ' + _exercise.title),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(_exercise.perk1),
                      Text(_exercise.perk2!),
                      Text(_exercise.perk3!),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: _height*0.7,
              width: _width,
              child: ListView.builder(itemCount: _exercise.description.length, itemBuilder: (BuildContext context, int index) {
                //child: ListView.builder(itemCount: 3, itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text(index.toString()),
                  title: Text(_exercise.description.elementAt(index)),
                  //title: Text('_exercise.description.elementAt(index)'),
                );
              },
              ),
            ),
            ElevatedButton(onPressed: () async {
              DatabaseReference _refExt = FirebaseDatabase.instance.ref().child('exercises');
              await _refExt.child(_exercise.title).set(_exercise.toJson());
              Navigator.pop(context);
            }, child: const Text('approve'))
          ],
        ),
      ),
    );
  }
}
