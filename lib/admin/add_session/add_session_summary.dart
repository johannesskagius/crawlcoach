import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SessionsSummary extends StatelessWidget {
  SessionsSummary(this._session, {Key? key}) : super(key: key);
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final Session _session;

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('summary'),
      ),
      body: SizedBox(
        width: _width,
        height: _height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Name: '),
                Text(_session.sessionName),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Desc: '),
                Text(_session.desc),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Nr och exercises: '),
                Text(_session.exercises.length.toString()),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () async {
          final user2 = await User2.getLocalUser();
          _session.uploadSession(user2!.userAuth);
          Navigator.pop(context);
        },
        child: const Text('To Server'),
      ),
    );
  }
}