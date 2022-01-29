import 'package:crawl_course_3/account/user.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Session _nextSession = Session('loading', '', <dynamic>[], '');

  //Todo should be moved
  void getEntrySessionsKies() async {
    List<String> _startingSessions = [];
    LocalUser? _local = await LocalUser.getLocalUser();
    List<String> _completed = await _local!.completedSession();
    
    DatabaseReference _ref = FirebaseDatabase.instance.ref();
    _ref
        .child('courses')
        .child('test')
        .child('session')
        .onValue
        .listen((event) async {
      for (DataSnapshot _snap in event.snapshot.children) {
        final String _session = _snap.value.toString();
        //Check if user already done session
        if (!_completed.contains(_session)) {
          // && !_doneSessions.contains(_session)
          _startingSessions.add(_session);
        }
      }
      DataSnapshot x = await _ref
          .child('sessions')
          .child(_startingSessions.elementAt(0))
          .get();
      setState(() {
        _nextSession = Session.fromJson(x.value);
      });
    });
  }

  @override
  void initState() {
    getEntrySessionsKies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SizedBox(
            height: _height,
            width: _width,
            child: Center(
                child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      height: _height * 0.9,
                      child: Container(
                        //Background
                        color: Colors.grey,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: _height * 0.2,
                          width: _width * .8,
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
                        SessionPreview(_nextSession)
                      ],
                    ),
                  ],
                ),
              ],
            ))));
  }
}
