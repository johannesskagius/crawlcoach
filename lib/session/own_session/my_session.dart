import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../account/user2.dart';
import '../session.dart';
import '../session_view_00.dart';

class MySessions extends StatefulWidget {
  const MySessions({Key? key}) : super(key: key);

  @override
  State<MySessions> createState() => _MySessionsState();
}

class _MySessionsState extends State<MySessions> {
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
      appBar: AppBar(
        title: const Text('My sessions'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
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
            Scrollbar(
              child: ListView.builder(
                itemCount: _completed.length,
                shrinkWrap: false,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(_completed.elementAt(index).sessionName),
                      trailing:
                          Text(_completed.elementAt(index).time.toString()),
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
            ),
          ],
        ),
      ),
    );
  }
}
