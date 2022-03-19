import 'package:crawl_course_3/session/session.dart';
import 'package:crawl_course_3/session/session_view_00.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../account/user2.dart';
import 'free_session.dart';

class OwnCoach extends StatefulWidget {
  const OwnCoach({Key? key}) : super(key: key);

  @override
  _OwnCoachState createState() => _OwnCoachState();
}

class _OwnCoachState extends State<OwnCoach> {
  List<Session> _completed = [];

  void _getCompleted() async {
    final _user = await User2.getLocalUser();
    DataSnapshot _data =
        await User2.ref.child(_user!.userAuth).child('my_sessions').get();
    for (DataSnapshot _snapshot in _data.children) {
      final _sess = Session.fromJson(_snapshot.value);
      _completed.add(_sess);
    }
    setState(() {});
  }

  @override
  void initState() {
    _getCompleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                margin: const EdgeInsets.all(8),
                //Show training calendar
                child: Card(
                  elevation: 8,
                  child: ListTile(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FreeSession()));
                    },
                    title: const Text('Start session'),
                  ),
                )),
            const Divider(
              height: 1,
            ),
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(
                width: 0.5,
                color: Colors.black,
              )),
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  const Text(
                    'Your saved session',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white38,
                    ),
                  ),
                  ListView.builder(
                    itemCount: _completed.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4,
                        child: ListTile(
                          title: Text(_completed.elementAt(index).sessionName),
                          onTap: () async {
                            final _user = await User2.getLocalUser();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Session00(
                                        session: _completed.elementAt(index),
                                        id: _user!.userAuth,
                                        offerName: 'OWN')));
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
