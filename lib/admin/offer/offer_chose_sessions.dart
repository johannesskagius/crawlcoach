
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'offer.dart';
import 'offer_summary.dart';



class ChooseSessions extends StatefulWidget {
  const ChooseSessions(this._name, this._desc, {Key? key}) : super(key: key);
  final String _name, _desc;

  @override
  _ChooseSessionsState createState() => _ChooseSessionsState();
}

class _ChooseSessionsState extends State<ChooseSessions> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  List<String> _chosens = [];
  int _nrChosen = 0;
  List<Session> _sessions = [];

  void _activateListener() async{
    List<Session> _downloadedSessions = [];
    _ref.child('sessions').onValue.listen((event) {
      for(var element in event.snapshot.children){
        Object? test = element.value;
        print(element.key);
        try{
          _downloadedSessions.add(Session.fromJson(test));
        }catch(e){
          print(e);
        }
      }

      setState(() {
        _sessions = _downloadedSessions;
      });
    });
  }

  void increment(int index){
    if(!_chosens.contains(_sessions.elementAt(index).sessionName)){
      _chosens.add(_sessions.elementAt(index).sessionName);
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
        title: const Text('Add exercises'),
      ),
      body: SizedBox(
        height: _height,
        width: _width,
        child:Stack(
          children: [
            SizedBox(
              height: _height,
              child: ListView.builder(
                itemCount: _sessions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: ()=> increment(index),
                      leading: Text(index.toString()),
                      title: Text(_sessions.elementAt(index).sessionName),
                      trailing: Text(_sessions.elementAt(index).desc),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OfferSummary(Offer(widget._name, widget._desc, _chosens))));
                  }, child: const Text('Go to summary'),),
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