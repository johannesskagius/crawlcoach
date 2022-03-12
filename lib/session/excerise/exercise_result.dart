import 'package:flutter/material.dart';

class ExerciseResults extends StatefulWidget {
  const ExerciseResults({Key? key}) : super(key: key);

  @override
  _ExerciseResultsState createState() => _ExerciseResultsState();
}

class _ExerciseResultsState extends State<ExerciseResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Results'),
      ),
      body: Column(
          //Graph over results
          //Best results at time,
          //Enter a new result
          ),
    );
  }
}
