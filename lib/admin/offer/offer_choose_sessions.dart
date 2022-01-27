
import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'offer_summary.dart';



class ChooseSessions extends StatefulWidget {
  ChooseSessions(this._name, this._desc, {Key? key}) : super(key: key);
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final String _name, _desc;

  @override
  _ChooseSessionsState createState() => _ChooseSessionsState();
}

class _ChooseSessionsState extends State<ChooseSessions> {
  List<String> _chosens = [];
  int _nrChosen = 0;
  List<Session> _exercises = [];

  void _activateListener(){
    List<Session> _ex = [];
    widget._ref.child('sessions').onValue.listen((event) {
      for (var element in event.snapshot.children) {
        Object? test = element.value;
        try {
          _ex.add(Session.fromJson(test));
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
    if(!_chosens.contains(_exercises.elementAt(index).sessionName)){
      _chosens.add(_exercises.elementAt(index).desc);
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
                      title: Text(_exercises.elementAt(index).sessionName),
                      trailing: Text(_exercises.elementAt(index).desc),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OfferSummary()));
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