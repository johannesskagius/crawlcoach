
import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'add_session_summary.dart';



class SessionExercises extends StatefulWidget {
  SessionExercises(this._name, this._desc, {Key? key}) : super(key: key);
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final String _name, _desc;

  @override
  _SessionExercisesState createState() => _SessionExercisesState();
}

class _SessionExercisesState extends State<SessionExercises> {
  List<Exercise> _chosens = [];
  int _nrChosen = 0;
  List<Exercise> _exercises = [];

  void _activateListener(){
    List<Exercise> _ex = [];
    widget._ref.child('exercises').onValue.listen((event) {
      for (var element in event.snapshot.children) {
        Object? test = element.value;
        try {
          _ex.add(Exercise.fromJson(test));
        } catch (e) {
          print('test');
        }
      }
      setState(() {
        _exercises = _ex;
      });
    });
  }

  void increment(int index){
    if(!_chosens.contains(_exercises.elementAt(index))){
      _chosens.add(_exercises.elementAt(index));
      setState(() {
        _nrChosen++;
      });
    }
  }

  @override
  void initState() {
    _activateListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add exercises'),
      ),
      body: SizedBox(
        height: _height,
        width: _width,
        child:Stack(
          children: [
            SizedBox(
              height: _height,
              child: ListView.builder(
                itemCount: _exercises.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: ()=> increment(index),
                      leading: Text(index.toString()),
                      title: Text(_exercises.elementAt(index).title),
                      trailing: Text(_exercises.elementAt(index).subTitle!),
                    ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SessionsSummary(Session(widget._name, widget._desc,_chosens,''))));
                  }, child: Text('Go to summary'),),
                  FloatingActionButton(
                      onPressed: (){
                        //TODO implement functions
                      },
                      child:Text(_nrChosen.toString())
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}