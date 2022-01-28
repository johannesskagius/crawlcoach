import 'dart:convert';

import 'package:crawl_course_3/session/session.dart';
import 'package:crawl_course_3/account/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _localUser = LocalUser.getLocalUser();
  String test = ' not';

  //change to load next session,
  Future<Session> getEntrySessions() async {
    DatabaseReference _ref = FirebaseDatabase.instance.ref();
    List<String> _startingSessions = [];

    DataSnapshot _sessionKeys = await _ref.child('courses').child('test').child('sessions').get();

    for(DataSnapshot _snap in _sessionKeys.children){
      final String _session = _snap.value.toString();
      if(!_startingSessions.contains(_session)){
        _startingSessions.add(_session);
      }
    }

    DataSnapshot singleSession = await _ref.child('sessions').child(_startingSessions.elementAt(0)).get();
    //final String fromSnapshot = singleSession.value;

    Session nextSession = Session.fromJson(singleSession.value);
    return nextSession;
  }



  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height-AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;



    @override
    void initState() {
      getEntrySessions();
      super.initState();
    }

    return Scaffold(
      body: SizedBox(
        height: _height,
        width: _width,
        child: FutureBuilder(future: getEntrySessions(),
          builder: (BuildContext context, AsyncSnapshot<Session> snapshot) {
          late Widget test;
            //String _userName='';
            if(snapshot.hasData && snapshot.data != null){
              test = SessionPreview(snapshot.requireData);
          }else{
              test = Text('test');
            }
            return Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      SizedBox(
                        height: _height*0.9,
                        child: Container(   //Background
                          color: Colors.grey,
                        ),
                      ),
                      Column(               //QUOTE
                        children: [
                          SizedBox(
                            height: _height*0.2,
                            width: _width*.8,
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Today is your opportunity to build the tomorrow you want',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          test,
                        ],
                      ),

                    ],
                  ),
                ],
              )
            );
          },
        )
      ),
    );
  }
}
