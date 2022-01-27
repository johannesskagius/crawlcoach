import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ExerciseViewPort extends StatelessWidget {
  const ExerciseViewPort({Key? key, required this.exercise}) : super(key: key);
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    double _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(exercise.title),
        ),
        body: SizedBox(
          height: _height,
          width: _width,
          child: Column(
            children: <Widget>[
              // SizedBox(
              //   width: _width,
              //   height: _height * 0.4,
              //   child: Container(
              //     color: Colors.black54,
              //     alignment: Alignment.center,
              //     child: Text('Video'),
              //   ),
              // ), //TODO show video of excercise,
              SizedBox(
                width: _width,
                height: _height * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: _width/3,
                        child: Text(exercise.perk1)
                    ),
                    SizedBox(
                      width: _width/3,
                      child:Text(exercise.perk2),
                    ),
                    SizedBox(
                      width: _width/3,
                      child: Text(exercise.perk3),
                    )
                  ],
                ),
              ),
              Expanded(child: ListView.builder(itemCount: exercise.description.length, itemBuilder: (BuildContext context, int index) {
                return Explained(number: index.toString(), description: exercise.description.elementAt(index), width: _width,);
              },))
            ],
          ),
        ));
  }
}




class ExerciseAsListTile extends StatelessWidget {
  final Exercise _exercise;
  final int _nrInOrder;
  const ExerciseAsListTile(this._exercise, this._nrInOrder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciseViewPort(exercise: _exercise)));
        },
        leading: Text(_nrInOrder.toString(), style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),),
        title: Text(_exercise.title),
        subtitle: Text(_exercise.subTitle),
        // trailing: Text(_exercise.nrTimes +
        //     'x' +
        //     _exercise.distance +
        //     ''), //Todo gäller antal just nu
      ),
    );
  }
}
