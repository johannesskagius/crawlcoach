import 'dart:io';

import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'offer.dart';
import 'offer_summary.dart';

class ChooseSessions extends StatefulWidget {
  ChooseSessions(this._name, this._price, this._desc, this.imgPath, {Key? key})
      : super(key: key);
  final String _name, _price, _desc;
  File? imgPath;

  @override
  _ChooseSessionsState createState() => _ChooseSessionsState();
}

class _ChooseSessionsState extends State<ChooseSessions> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  List<String> _chosens = [];
  final Map<String, String> _chosens2 = {};
  int _nrChosen = 0;
  List<Session> _sessions = [];

  void _activateListener() async {
    List<Session> _downloadedSessions = [];
    final user2 = await User2.getLocalUser();
    _ref.child('sessions').child(user2!.userAuth).onValue.listen((event) {
      for (DataSnapshot element in event.snapshot.children) {
        Object? test = element.value;
        _downloadedSessions.add(Session.fromJson(test));
      }
      setState(() {
        _sessions = _downloadedSessions;
      });
    });
  }

  void increment(int index) {
    if (!_chosens.contains(_sessions.elementAt(index).sessionName)) {
      _chosens2[_sessions.elementAt(index).sessionName] = widget._name;
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
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add exercises'),
      ),
      body: SizedBox(
        height: _height,
        width: _width,
        child: Stack(
          children: [
            SizedBox(
              height: _height,
              child: ListView.builder(
                itemCount: _sessions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: () => increment(index),
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
                  ElevatedButton(
                    onPressed: () async {
                      final _user = await User2.getLocalUser();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OfferSummary(
                                  Offer(
                                      name: widget._name,
                                      listOfSessions: _chosens2,
                                      price: widget._price,
                                      desc: widget._desc,
                                      userID: _user!.userAuth),
                                  widget.imgPath)));
                    },
                    child: const Text('Go to summary'),
                  ),
                  FloatingActionButton(
                      onPressed: () {
                        //TODO implement functions
                      },
                      child: Text(_nrChosen.toString())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
