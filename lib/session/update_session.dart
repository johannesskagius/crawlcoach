import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';

class UpdateSession extends StatelessWidget {
  const UpdateSession(this._session, {Key? key}) : super(key: key);
  final Session _session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_session.sessionName),
      ),
      body: sessionCon(_session, context),
    );
  }
}

Container sessionCon(Session _session, BuildContext context) {
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
          _session.previewTable(_width, _height),
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
                Session.sessionRef
                    .child(user2!.userAuth)
                    .child(_session.sessionName)
                    .remove();
              },
              child: const Text('Delete session')),
        ],
      ),
    ),
  );
}
