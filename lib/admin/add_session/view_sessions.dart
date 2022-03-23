import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:crawl_course_3/session/update_session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ViewSessions extends StatefulWidget {
  const ViewSessions({Key? key}) : super(key: key);

  @override
  State<ViewSessions> createState() => _ViewSessionsState();
}

class _ViewSessionsState extends State<ViewSessions> {
  List<Session> _sessions = [];
  User2? _user;

  void _getSessions() async {
    _user = await User2.getLocalUser();
    List<Session> _exer = [];
    DataSnapshot snapshot =
        await Session.sessionRef.child(_user!.userAuth).get();
    for (DataSnapshot data in snapshot.children) {
      _exer.add(Session.fromJson(data.value));
    }
    setState(() {
      _sessions = _exer;
    });
  }

  @override
  void initState() {
    _getSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Sessions',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
        body: ListView.builder(
          itemCount: _sessions.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateSession(
                              _user!, _sessions.elementAt(index))));
                },
                leading: Text(
                  index.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(_sessions.elementAt(index).sessionName),
                subtitle: Text(_sessions.elementAt(index).desc),
              ),
            );
          },
        ));
  }
}
