import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';

class UpdateSession extends StatelessWidget {
  const UpdateSession(this._user, this._session, {Key? key}) : super(key: key);
  final Session _session;
  final User2 _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_session.sessionName),
      ),
      body: sessionCon(_session, context, _user),
      resizeToAvoidBottomInset: false,
    );
  }
}

Container sessionCon(Session _session, BuildContext context, User2 _user) {
  final _width = MediaQuery.of(context).size.width;
  final _height =
      MediaQuery.of(context).size.height - AppBar().preferredSize.height;
  return Container(
    margin: const EdgeInsets.all(8),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: Image.asset('assets/crawl.jpeg'),
          ),
          //info about the session,
          _session.previewTable(_user.userAuth, _width, _height, context),
          //Exercises
          ListView.builder(
            itemCount: _session.exercises.keys.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title:
                      Text(_session.exercises.keys.elementAt(index).toString()),
                ),
              );
            },
          ),
          //delete
          ElevatedButton(
              onPressed: () async {
                final user2 = await User2.getLocalUser();
                _session.removeSession(user2!.userAuth);
                Navigator.pop(context);
              },
              child: const Text('Delete session')),
        ],
      ),
    ),
  );
}
